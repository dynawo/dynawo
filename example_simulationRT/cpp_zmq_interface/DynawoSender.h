#ifndef DYNAWO_SENDER_H
#define DYNAWO_SENDER_H

#include <deque>
#include <string>
#include <zmqpp/zmqpp.hpp>
#include <mutex>

class DynawoSender {
    public:
        DynawoSender(int port);

        /**
         * Send a command to Dynawo.
         * The command is actually saved in a queue, and will be sent to Dynawo on the next goToNextTimeStep() call
         */
        void sendAction(const std::string& command);

        /**
         * Push queued commands, then send a signal to Dynawo to proceed to the next time step (via empty command)
         * Returns "continue" if Dynawo correctly handled the command and proceeds to the next time step
         * Returns "stop" if Dynawo was interrupted
         */
        std::string goToNextTimeStep();

        void stopDynawo();
    private:
        zmqpp::context context_;
        zmqpp::socket socket_;
        zmqpp::poller poller_;
        std::deque<std::string> action_queue;
        std::mutex mutex_;
};

#endif // DYNAWO_SENDER_H
