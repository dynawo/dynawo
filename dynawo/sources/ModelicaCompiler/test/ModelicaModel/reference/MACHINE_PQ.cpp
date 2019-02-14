
#include "MACHINE_PQ.h"
#include "DYNSubModel.h"
#include "MACHINE_PQ_Dyn.h"
#include "MACHINE_PQ_Init.h"

extern"C" DYN::SubModelFactory * getFactory()
{
  return (new DYN::ModelMACHINE_PQFactory());
}

extern "C" DYN::SubModel * DYN::ModelMACHINE_PQFactory::create() const
{
  DYN::SubModel * model (new DYN::ModelMACHINE_PQ() );
  return model;
}

namespace DYN {

ModelMACHINE_PQ::ModelMACHINE_PQ()
{
  modelType_ = std::string("MACHINE_PQ");
  modelDyn_ = NULL;
  modelInit_ = NULL;
  modelDyn_ = new ModelMACHINE_PQ_Dyn();
  modelDyn_->setModelManager(this);
  modelDyn_->setModelType(this->modelType());
  modelInit_ = new ModelMACHINE_PQ_Init();
  modelInit_->setModelManager(this);
  modelInit_->setModelType(this->modelType());
}

ModelMACHINE_PQ::~ModelMACHINE_PQ()
{
  delete modelDyn_;
  delete modelInit_;
}

}


