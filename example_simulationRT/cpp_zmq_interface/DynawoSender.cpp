#include "DynawoSender.h"

#include <sstream>

DynawoSender::DynawoSender(int port):
socket_(context_, zmqpp::socket_type::req) {
    std::stringstream address;
    address << "tcp://localhost:" << port;
    socket_.connect(address.str());
    poller_.add(socket_);
}

void DynawoSender::sendAction(const std::string& command) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (command == "") {
        std::cout << "Warning, emtpy command is reserved for goToNextTimeStep(), command disregarded" << std::endl;
    } else if (command == "stop") {
        std::cout << "Warning, 'stop' command is reserved for stopDynawo(), command disregarded" << std::endl;
    } else {
        action_queue.push_back(command);
    }
}

std::string DynawoSender::goToNextTimeStep() {
    std::lock_guard<std::mutex> lock(mutex_);  // Non thread-safe (need to wait for reply before allowing other threads to send)
    action_queue.push_back("");  // Empty command means goToNextTimeStep
    while (!action_queue.empty()) {  // First push all queued commands
        std::string command = action_queue.front();
        action_queue.pop_front();

        zmqpp::message message;
        message << command;
        socket_.send(message);
        std::cout << "Sending action: " << command << std::endl;

        // Polling
        while (!poller_.poll(1000)) {
            std::cout << "DynawoSender: waiting acknowledgement" << std::endl;
        }

        zmqpp::message zmq_reply;
        socket_.receive(zmq_reply);
        std::string reply;
        zmq_reply >> reply;
        std::cout << "Sender: Dynawo replied with " << reply << std::endl;
        if (reply == "stop signal" || reply == "simulation ended")
            return "stop";
    }
    return "continue";
}

void DynawoSender::stopDynawo() {
    std::lock_guard<std::mutex> lock(mutex_);
    action_queue.clear();

    zmqpp::message message;
    message << "stop";
    socket_.send(message);
    std::cout << "Stopping Dynawo" << std::endl;
    // Do not wait for a reply from Dynawo as it might not send it if it is interrupted
}
