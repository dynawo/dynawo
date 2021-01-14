
#include "GeneratorPQ.h"
#include "DYNSubModel.h"
#include "GeneratorPQ_Dyn.h"
#include "GeneratorPQ_Init.h"

extern "C" DLL_PUBLIC DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelGeneratorPQFactory());
}

extern "C" DLL_PUBLIC void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelGeneratorPQFactory::create() const
{
  DYN::SubModel* model (new DYN::ModelGeneratorPQ() );
  return model;
}

extern "C" void DYN::ModelGeneratorPQFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelGeneratorPQ::ModelGeneratorPQ() {
  modelType_ = std::string("GeneratorPQ");
  modelDyn_ = NULL;
  modelInit_ = NULL;
  modelDyn_ = new ModelGeneratorPQ_Dyn();
  modelDyn_->setModelManager(this);
  modelDyn_->setModelType(this->modelType());
  modelInit_ = new ModelGeneratorPQ_Init();
  modelInit_->setModelManager(this);
  modelInit_->setModelType(this->modelType());
}

ModelGeneratorPQ::~ModelGeneratorPQ() {
  delete modelDyn_;
  delete modelInit_;
}

}


