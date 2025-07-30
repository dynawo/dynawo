
#include "DYNInputDispatcherAsync.h"

#include "DYNInputInterface.h"

#include <vector>
#include <functional>
#include <iostream>
#include <atomic>

namespace DYN {

InputDispatcherAsync::InputDispatcherAsync(std::shared_ptr<ActionBuffer> &actionBuffer, std::shared_ptr<TimeManager>& timeManager) :
  actionBuffer_(actionBuffer),
  timeManager_(timeManager),
  running_(false) {}

InputDispatcherAsync::~InputDispatcherAsync() {
  stop();
}

void
InputDispatcherAsync::addReceiver(std::shared_ptr<InputInterface>& receiver) {
  receivers_.push_back(receiver);
}

void
InputDispatcherAsync::start() {
  std::cout << "InputDispatcherAsync::start receivers_.size() = " << receivers_.size() << std::endl;
  bool useTrigger = false;

  for (auto receiver: receivers_)
    useTrigger |= receiver->supports(MessageFilter::TimeManagement);
  timeManager_->setUseTrigger(useTrigger);

  for (auto receiver: receivers_)
    receiver->startReceiving([this](std::shared_ptr<InputMessage> msg){ this->dispatchMessage(std::move(msg)); }, true);
  processorThread_ = std::thread([this](){ processLoop(); });
  running_ = true;
}

void
InputDispatcherAsync::stop() {
  running_ = false;
  queueCond_.notify_all();
  for (auto receiver: receivers_)
    receiver->stop();
  if (processorThread_.joinable())
    processorThread_.join();
}

void
InputDispatcherAsync::dispatchMessage(std::shared_ptr<InputMessage> msg) {
    if (msg) {
      {
        std::lock_guard<std::mutex> lock(queueMutex_);
        messageQueue_.push(std::move(msg));
      }
      queueCond_.notify_one();
    }
}

void
InputDispatcherAsync::processLoop() {
  while (running_) {
    std::unique_lock<std::mutex> lock(queueMutex_);
    queueCond_.wait(lock, [this]()
                    { return !messageQueue_.empty() || !running_; });

    while (!messageQueue_.empty()) {
      auto msg = messageQueue_.front();
      messageQueue_.pop();
      lock.unlock();

      switch (msg->getType()) {
        case MessageType::Action:
          actionBuffer_->registerAction(static_cast<ActionMessage &>(*msg));
          break;
        case MessageType::StepTrigger:
          timeManager_->handleMessage(static_cast<StepTriggerMessage &>(*msg));
          break;
        case MessageType::Stop:
          timeManager_->handleMessage(static_cast<StopMessage &>(*msg));
          break;
      }

      lock.lock();
    }
  }
}

} // end of namespace DYN
