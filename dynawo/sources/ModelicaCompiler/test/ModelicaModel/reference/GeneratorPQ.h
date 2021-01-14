
#ifndef GeneratorPQ_h
#define GeneratorPQ_h
#include "DYNModelManager.h"
#include "DYNSubModelFactory.h"
#include "DYNVisibility.h"

namespace DYN {

  class ModelGeneratorPQFactory : public SubModelFactory
  {
    public:
    ModelGeneratorPQFactory() {}
    ~ModelGeneratorPQFactory() {}

    DLL_PUBLIC SubModel* create() const;
    DLL_PUBLIC void destroy(SubModel*) const;
  };

  class ModelGeneratorPQ : public ModelManager
  {
    public:
    ModelGeneratorPQ();
    ~ModelGeneratorPQ();

    bool hasInit() const { return true; }
  };
}

#endif

