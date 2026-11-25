
#ifndef GeneratorPQ_h
#define GeneratorPQ_h
#include "DYNModelManager.h"
#include "DYNSubModelFactory.h"

namespace DYN {

  class ModelGeneratorPQFactory : public SubModelFactory
  {
    public:
    ModelGeneratorPQFactory() {}
    ~ModelGeneratorPQFactory() {}

    SubModel* create() const;
    void destroy(SubModel*) const;
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
