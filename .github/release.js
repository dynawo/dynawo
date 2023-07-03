/* usage in a workflow.yml:

      - uses: actions/github-script@v6
        env:                                # Input parameters for release script
          ...see below
        with:                               # Input parameters for github-script action (see https://github.com/actions/github-script/tree/v6/)
          github-token: ${{ secrets.PAT }}  # optional separate GitHub token to enhance permissions (secrets.GITHUB_TOKEN by default)
          retries: 3                        # optional number of retries for request failures (none by default)
          script: |                         # minimum script to call release script
            const release = require('.github/workflows/release.js')
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
  
  try {
    const per_page = 10;              // number of releases per page while retrieving list of releases
    const retries_find_release = 10;  // number of retries to find a newly created release
    const delay_find_release = 500;   // delay in ms between two attempts to find a newly created release
    const retries_upload_asset = 5;   // number of retries to upload an asset
    const delay_upload_asset = 500;   // delay in ms between two attempts to upload an asset

    // input parameters read from process.env (env: keyword in workflow.yml)
    const {
      owner,                      // owner of the repository (current owner by default)
      repo,                       // repository (current repo by default)
      tag_name,                   // required tag for the release (created if not exist)
      target_commitish,           // commit reference to create tag (required only if tag doesn't exist already)
      files,                      // optional glob patterns to identify assets (see https://github.com/actions/toolkit/tree/main/packages/glob)
      release_name,               // name for the release (value of tag_name by default)
      body,                       // description body of the release (none by default), maybe multilines, **markdown** is allowed
      draft,                      // set to true to mark release as draft (false by default)
      prerelease,                 // set to true to mark release as prerelease (false by default)
      discussion_category_name,   // create and link to the release a discussion of the specified category (none by default)
      generate_release_notes,     // set to true to automatically generate release notes (false by default)
      delete_release,             // set to true to always delete an existing release (false by default to delete it only if necessary)
      append_body,                // in case of update, set to true to append or false to prepend new body to body of existing release (none by default to replace body) 
      fail_on_files_errors,       // set to true to fail script if error occurs while deleting or uploading assets (false by default)
    } = {
      owner:                      getInput('owner', context.repo.owner),
      repo:                       getInput('repo', context.repo.repo),
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
      append_body:                getBooleanInput('append_body'),
      fail_on_files_errors:       getBooleanInput('fail_on_files_errors', false),
    };

    /*
    console.log({
      owner,
      repo,
      tag_name,
      target_commitish,
      files,
      release_name,
      body,
      draft,
      prerelease,
      discussion_category_name,
      generate_release_notes,
      delete_release,
      append_body,
      fail_on_files_errors
    });
    */

    if (!tag_name) {
      throw new Error("'tag_name' is mandatory to create or identify a release");
    }

    let sha_tag;
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

    let sha_target;
    if (target_commitish) {
      try {
        ({ data: { object: { sha: sha_target } } } =
          await github.rest.git.getRef({
            owner,
            repo,
            ref: target_commitish
          })
        );
        console.log(`💡SHA for 'target_commitish=${target_commitish}' is: ${sha_target}`);
      } catch (error) {
        throw new Error(`Unable to get SHA for 'target_commitish=${target_commitish}': ${error.message}`);
      }
    }

    // getReleaseByTag() is unable to find draft releases
    let release;
    try {
      const iterator = github.paginate.iterator(github.rest.repos.listReleases, {
        owner,
        repo,
        per_page
      });
      for await (const { data: releases } of iterator) {
        release = releases.find(item => item.tag_name === tag_name);
        if (release) {
          break;
        }
      }
    } catch (error) {
      throw new Error(`Unable to retrieve list of releases: ${error.message}`);
    }

    if (release) {
      console.log(`🎁Found a ${release.draft && 'draft ' || ''}release with id ${release.id} for tag '${release.tag_name}'`);
    } else {
      console.log(`💡No actual release found for tag '${tag_name}'`);
    }

    // renew tag if no actual tag or sha has changed
    let new_tag = false;
    if (!sha_tag || (target_commitish && sha_tag !== sha_target)) {
      new_tag = true;
      console.log("💡New tag is needed");
    }
    // renew release if tag is renew or no actual release or delete release is requested
    let new_release = false;
    if (new_tag || !release || delete_release) {
      new_release = true;
      console.log("💡New release is needed");
    }

    if (new_tag && !target_commitish) {
      throw new Error("'target_commitish' is mandatory to create tag");
    }

    if (new_release) {
      if (release) {
        try {
          console.log(`♻️Deleting previous release with id ${release.id}...`);
          await github.rest.repos.deleteRelease({
            owner,
            repo,
            release_id: release.id
          });
        } catch (error) {
          throw new Error(`Unable to delete previous release: ${error.message}`);
        }
      }

      if (new_tag && sha_tag) {
        try {
          console.log(`♻️Deleting previous tag '${tag_name}'...`);
          await github.rest.git.deleteRef({
            owner,
            repo,
            ref: `tags/${tag_name}`
          });
        } catch (error) {
          throw new Error(`Unable to delete previous tag: ${error.message}`);
        }
      }

      try {
        const using_commit = new_tag && ` using commit '${target_commitish}'` || "";
        console.log(`🛠️Creating new release for tag '${tag_name}'${using_commit}...`);
        ({ data: release } =
          await github.rest.repos.createRelease({
            owner,
            repo,
            tag_name,
            target_commitish: new_tag && sha_target || undefined,
            name: release_name ?? tag_name,
            body,
            draft,
            prerelease,
            discussion_category_name,
            generate_release_notes
          })
        );
      } catch (error) {
        throw new Error(`Unable to create a new release: ${error.message}`);
      }

      core.startGroup(`💡Waiting for new release with id ${release.id} to be ready...`);
      await (async () => {
        for (let i = 1; i <= retries_find_release; i++) {
          await new Promise(r => setTimeout(r, delay_find_release));
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
      core.endGroup();

    } else if (release) {
      if (draft && !release.draft) {
        console.log("⚠️Cannot convert a non-draft release to draft");
      }
      // update the release if any of these conditions
      if ([
            release_name !== undefined && release.name !== release.name,
            body !== undefined,
            draft !== undefined && draft !== release.draft,
            prerelease !== undefined && prerelease !== release.prerelease,
            discussion_category_name !== undefined,
            generate_release_notes !== undefined
          ].some(condition => condition)) {
        try {
          console.log(`🛠️Updating existing release for tag '${tag_name}'...`);
          let new_body = body || "";
          if (body === undefined) {
            new_body = release.body;
          } else if (append_body !== undefined && release.body) {
            new_body = (append_body === true && `${release.body}\n` || "") + new_body + (append_body === false && `\n${release.body}` || "")
          }
          ({ data: release } =
            await github.rest.repos.updateRelease({
              owner,
              repo,
              release_id: release.id,
              name: release_name === undefined ? release.name : release_name,
              body: new_body,
              draft: draft === undefined ? release.draft : draft,
              prerelease: prerelease === undefined ? release.prerelease : prerelease,
              discussion_category_name,
              generate_release_notes
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
              console.log(`👌Asset '${new_asset.name}' successfully upload with id ${new_asset.id }`);
              release.assets.push(new_asset);
              return;
            } catch (error) {
              console.log(`⚠️Unable to upload asset '${path}': ${error.message}`);
            }
            await new Promise(r => setTimeout(r, delay_upload_asset));
          }
          throw new Error(`Unable to upload asset '${path}': Too many retries. Aborting...`);
        })();
        core.endGroup();

      } catch (error) {
        if (fail_on_files_errors) {
          throw error;
        } else {
          console.log(`⚠️${error.message}`);
        }
      }
    }

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
