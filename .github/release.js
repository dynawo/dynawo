/* usage in a workflow.yml:

      - uses: actions/github-script@v6
        env:                                # Input parameters for release script
          ...see below
        with:                               # Input parameters for github-script action (see https://github.com/actions/github-script/tree/v6/)
          github-token: ${{ secrets.PAT }}  # optional separate GitHub token to enhance permissions (secrets.GITHUB_TOKEN by default)
          retries: 3                        # optional number of retries for request failures (none by default)
          script: |                         # minimum script to call release script
            const release = require('.github/release.js')
            await release({github, context, core, glob})
*/

module.exports = async ({github, context, core, glob}) => {
  // console.log({env: process.env});

  function getInput(name, by_default = undefined) {
    const val = process.env[name] || by_default;
    return val?.trim();
  }

  function getBooleanInput(name, by_default = undefined) {
    const trueValue = [true, 'true', 'True', 'TRUE'];
    const falseValue = [false, 'false', 'False', 'FALSE'];
    const val = getInput(name) || by_default;
    if (val === undefined) return undefined;
    if (trueValue.includes(val)) return true;
    if (falseValue.includes(val)) return false;
    throw new TypeError(
      `Input does not meet YAML 1.2 "Core Schema" specification: ${name}\n` +
        `Support boolean input list: \`true | True | TRUE | false | False | FALSE\``
    )
  }

  // check if string is a valid SHA-1 hash
  function isSHA1(str) {
    const regex = /^[a-f0-9]{40}$/gi;
    return regex.test(str);
  }

  try {
    const per_page = 10;              // number of releases per page while retrieving list of releases
    const retries_find_release = 10;  // number of retries to find a newly created release
    const delay_find_release = 500;   // base delay in ms between two attempts to find a newly created release (real delay is increased with base delay at each attempt)
    const retries_upload_asset = 10;  // number of retries to upload an asset
    const delay_upload_asset = 500;   // base delay in ms between two attempts to upload an asset (real delay is increased with base delay at each attempt)

    // input parameters read from process.env (env: keyword in workflow.yml)
    const {
      owner,                      // owner of the repository (current owner by default)
      repo,                       // repository (current repo by default)
      release_id,                 // id of the release to update, may be 'latest' to identify the latest release (required if no tag_name is given)
      tag_name:                   // tag to identify the release to update or to create a new release, created if not exist (required if no release_id is given)
        input_tag_name,
      target_commitish:           // commit reference to create tag (required only if tag_name doesn't exist already)
        input_target_commitish,
      files,                      // optional glob patterns to identify files to upload as assets (see https://github.com/actions/toolkit/tree/main/packages/glob)
      release_name,               // name for the release (value of tag_name by default when creating a release)
      body,                       // description of the release (none by default), may be multilines, **markdown** is allowed
      draft,                      // set to true to mark release as draft (false by default)
      prerelease,                 // set to true to mark release as prerelease (false by default)
      discussion_category_name,   // create and link to the release a discussion of the specified category (none by default)
      generate_release_notes,     // set to true to automatically generate release notes (false by default)
      delete_release,             // set to true to always delete an existing release (false by default)
      after_body,                 // more description appended after body
      before_body,                // more description prepended before body
      fail_on_files_errors,       // set to true to cause the script to fail if an error occurs while deleting or uploading assets (false by default)
    } = {
      owner:                      getInput('owner', context.repo.owner),
      repo:                       getInput('repo', context.repo.repo),
      release_id:                 getInput('release_id'),
      tag_name:                   getInput('tag_name'),
      target_commitish:           getInput('target_commitish'),
      files:                      getInput('files'),
      release_name:               getInput('release_name'),
      body:                       getInput('body'),
      draft:                      getBooleanInput('draft'),
      prerelease:                 getBooleanInput('prerelease'),
      discussion_category_name:   getInput('discussion_category_name'),
      generate_release_notes:     getBooleanInput('generate_release_notes'),
      delete_release:             getBooleanInput('delete_release', false),
      after_body:                 getInput('after_body'),
      before_body:                getInput('before_body'),
      fail_on_files_errors:       getBooleanInput('fail_on_files_errors', false),
    };

    /*
    console.log({
      owner,
      repo,
      release_id,
      tag_name: input_tag_name,
      target_commitish: input_target_commitish,
      files,
      release_name,
      body,
      draft,
      prerelease,
      discussion_category_name,
      generate_release_notes,
      delete_release,
      after_body,
      before_body,
      fail_on_files_errors
    });
    */

    if (!input_tag_name && !release_id) {
      throw new Error("'release_id' or 'tag_name' is mandatory to identify or create a release");
    }

    let previous_release;
    if ((release_id || "").toUpperCase() === "LATEST") {
      try {
        ({ data: previous_release } =
          await github.rest.repos.getLatestRelease({
            owner,
            repo
          })
        );
        console.log(`🎁Found the latest published release with id ${previous_release.id} and tag '${previous_release.tag_name}'`);
      } catch (error) {
        throw new Error(`No latest published release is available: ${error.message}`);
      }
    }

    if (!previous_release && release_id !== undefined) {
      try {
        ({ data: previous_release } =
          await github.rest.repos.getRelease({
            owner,
            repo,
            release_id: +release_id
          })
        );
        console.log(`🎁Found the ${previous_release.draft && 'draft ' || ''}release for id ${previous_release.id} and with tag '${previous_release.tag_name}'`);
      } catch (error) {
        throw new Error(`Unable to get a release for 'release_id=${release_id}': ${error.message}`);
      }
    }

    // getReleaseByTag() is unable to find draft releases
    // and non-draft couldn't be converted to draft
    if (!previous_release && !draft) {
      try {
        ({ data: previous_release } =
          await github.rest.repos.getReleaseByTag({
            owner,
            repo,
            tag: input_tag_name
          })
        );
        console.log(`🎁Found the published release with id ${previous_release.id} for tag '${previous_release.tag_name}'`);
      } catch (error) {
      }
    }

    // if no non-draft release was found, look for the first draft release with the right tag in all releases
    if (!previous_release) {
      try {
        const iterator = github.paginate.iterator(github.rest.repos.listReleases, {
          owner,
          repo,
          per_page
        });
        for await (const { data: releases } of iterator) {
          previous_release = releases.find(item => item.draft && item.tag_name === input_tag_name);
          if (previous_release) {
            console.log(`🎁Found a draft release with id ${previous_release.id} for tag '${previous_release.tag_name}'`);
            break;
          }
        }
      } catch (error) {
        throw new Error(`Unable to retrieve list of releases: ${error.message}`);
      }
    }

    if (!previous_release) {
      console.log(`💡No actual release found for tag '${input_tag_name}'`);
    }

    // reused tag_name from existing release if no input tag_name is provided
    let tag_name = input_tag_name || previous_release?.tag_name;
    let sha_tag;
    if (tag_name) {
      try {
        ({ data: { object: { sha: sha_tag } } } =
          await github.rest.git.getRef({
            owner,
            repo,
            ref: `tags/${tag_name}`
          })
        );
        console.log(`💡SHA for 'tag_name=${tag_name}' is: ${sha_tag}`);
      } catch (error) {
        console.log(`💡Unable to get SHA for 'tag_name=${tag_name}': ${error.message}`);
      }
    }

    // target_commitish should be a commit SHA or a branch name
    let target_commitish = input_target_commitish;
    let sha_target;
    if (target_commitish) {
      try {
        const HEADS = 'heads/';
        if (isSHA1(target_commitish)) {
          // commit SHA
          ({ data: { sha: sha_target } } =
            await github.rest.git.getCommit({
              owner,
              repo,
              commit_sha: target_commitish
            })
          );
        } else {
          // branch name
          if (!target_commitish.startsWith(HEADS)) {
            target_commitish = `${HEADS}${target_commitish}`;
          }
          ({ data: { object: { sha: sha_target } } } =
            await github.rest.git.getRef({
              owner,
              repo,
              ref: target_commitish
            })
          );
        }
        console.log(`💡SHA for 'target_commitish=${target_commitish}' is: ${sha_target}`);
        if (target_commitish.startsWith(HEADS)) {
          target_commitish = target_commitish.slice(HEADS.length);
        }
      } catch (error) {
        throw new Error(`Unable to get SHA for 'target_commitish=${target_commitish}': ${error.message}`);
      }
    }

    if (!sha_tag && !target_commitish) {
      throw new Error(`'target_commitish' is mandatory to create tag '${tag_name}'`);
    }

    // update obsolete tag if sha has changed
    if (sha_tag && sha_target && sha_tag !== sha_target) {
      try {
        console.log(`🏷️Updating tag '${tag_name}'...`);
        await github.rest.git.updateRef({
          owner,
          repo,
          ref: `tags/${tag_name}`,
          sha: sha_target
        });
        sha_tag = sha_target;
      } catch (error) {
        throw new Error(`Unable to update tag: ${error.message}`);
      }
    }

    // delete previous release only if it is requested
    let release = previous_release;
    if (previous_release && delete_release) {
      try {
        console.log(`♻️Deleting previous release with id ${previous_release.id}...`);
        await github.rest.repos.deleteRelease({
          owner,
          repo,
          release_id: previous_release.id
        });
        release = undefined;
      } catch (error) {
        throw new Error(`Unable to delete previous release: ${error.message}`);
      }
    }

    // concatenate bodies if requested
    let new_body = body ?? previous_release?.body;
    new_body = before_body && new_body ? `${before_body}\n${new_body}` : before_body ?? new_body;
    new_body = new_body && after_body ? `${new_body}\n${after_body}` : after_body ?? new_body;

    const using_commit = !sha_tag && ` using commit '${target_commitish}'` || "";
    if (!release) {
      try {
        console.log(`🛠️Creating new release for tag '${tag_name}'${using_commit}...`);
        ({ data: release } =
          await github.rest.repos.createRelease({
            owner,
            repo,
            tag_name,
            target_commitish,
            name: release_name ?? previous_release?.name ?? tag_name,
            body: new_body,
            draft: draft ?? previous_release?.draft,
            prerelease: prerelease ?? previous_release?.prerelease,
            discussion_category_name,
            generate_release_notes
          })
        );
      } catch (error) {
        throw new Error(`Unable to create a new release: ${error.message}`);
      }

      try {
        core.startGroup(`💡Waiting for new release with id ${release.id} to be ready...`);
        await (async () => {
          for (let i = 1; i <= retries_find_release; i++) {
            await new Promise(r => setTimeout(r, delay_find_release * i));
            console.log(`💡${i}/${retries_find_release} - Looking for new release in all releases...`);
            try {
              const iterator = github.paginate.iterator(github.rest.repos.listReleases, {
                owner,
                repo,
                per_page
              });
              for await (const { data: releases } of iterator) {
                const release_found = releases.find(item => item.id === release.id);
                if (release_found) {
                  console.log(`🎁Found a ${release_found.draft && 'draft ' || ''}release with tag '${release_found.tag_name}'`);
                  return;
                } else {
                  console.log("⚠️New release not ready yet");
                }
              }
            } catch (error) {
              throw new Error(`Unable to retrieve list of releases: ${error.message}`);
            }
          }
          // not really an error here, the version exists although it is not ready yet
        })();
      } finally {
        core.endGroup();
      }

    } else  {
      if (draft && !previous_release.draft) {
        console.log("⚠️Cannot convert a non-draft release to draft");
      }
      // update the release if any of these conditions
      if ([
            tag_name !== previous_release.tag_name,
            release_name !== undefined && release_name !== previous_release.name,
            new_body !== previous_release.body,
            draft !== undefined && draft !== previous_release.draft,
            prerelease !== undefined && prerelease !== previous_release.prerelease,
            discussion_category_name !== undefined
          ].some(condition => condition)) {
        try {
          console.log(`🛠️Updating existing release for tag '${tag_name}'${using_commit}...`);
          ({ data: release } =
            await github.rest.repos.updateRelease({
              owner,
              repo,
              release_id: previous_release.id,
              tag_name,
              target_commitish,
              name: release_name ?? previous_release?.name,
              body: new_body,
              draft: draft ?? previous_release?.draft,
              prerelease: prerelease ?? previous_release?.prerelease,
              discussion_category_name
            })
          );
        } catch (error) {
          throw new Error(`Unable to update existing release: ${error.message}`);
        }
      }
    }

    const { readFileSync } = require('fs');
    const { basename } = require('path');

    const globber = await glob.create(files || "", {followSymbolicLinks: false, matchDirectories: false});
    for await (const path of globber.globGenerator()) {
      const name = basename(path);

      try {
        const previous_asset = release.assets.find(asset => asset.name === name);
        if (previous_asset) {
          try {
            console.log(`♻️Deleting previously uploaded asset '${name}'...`);
            await github.rest.repos.deleteReleaseAsset({
              owner,
              repo,
              asset_id: previous_asset.id
            });
            release.assets = release.assets.filter(asset => asset.id !== previous_asset.id);
          } catch (error) {
            throw new Error(`Unable to delete previously uploaded asset '${name}': ${error.message}`);
          }
        }

        try {
          core.startGroup(`⬆️Uploading asset '${path}'...`);
          await (async () => {
            for (let i = 1; i <= retries_upload_asset; ++i) {
              console.log(`💡${i}/${retries_upload_asset} - Upload attempt...`);
              try {
                const { data: new_asset } =
                  await github.rest.repos.uploadReleaseAsset({
                    owner,
                    repo,
                    release_id: release.id,
                    name,
                    data: await readFileSync(path)
                  });
                console.log(`👌Asset '${new_asset.name}' successfully uploaded with id ${new_asset.id }`);
                release.assets.push(new_asset);
                return;
              } catch (error) {
                console.log(`⚠️Unable to upload asset '${path}': ${error.message}`);
              }
              await new Promise(r => setTimeout(r, delay_upload_asset * i));
            }
            throw new Error(`Unable to upload asset '${path}': Too many retries. Aborting...`);
          })();
        } finally {
          core.endGroup();
        }

      } catch (error) {
        if (fail_on_files_errors) {
          throw error;
        } else {
          console.log(`⚠️${error.message}`);
        }
      }
    }

    // remove uploader section from assets
    release.assets.forEach(asset => delete asset.uploader);

    // outputs for subsequent steps or actions
    core.setOutput("assets", release.assets);             // JSON array containing information about each uploaded asset, in the format given at https://docs.github.com/en/rest/releases/assets#get-a-release-asset (minus the uploader field)
    core.setOutput("release_id", release.id.toString());  // Release ID as a string
    core.setOutput("html_url", release.html_url);         // Github.com URL for the release
    core.setOutput("upload_url", release.upload_url);     // URL for uploading assets to the release

    console.log(`🎉Release ready at ${release.html_url}`);

    return release;

  } catch (error) {
    core.setFailed(`🚨${error.message}`);
  }
}
