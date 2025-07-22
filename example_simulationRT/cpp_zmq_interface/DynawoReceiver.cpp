#include "DynawoReceiver.h"

#include <sstream>

DynawoReceiver::DynawoReceiver(int port, const std::string& topic):
socket_(context_, zmqpp::socket_type::sub),
topic_(topic) {
    std::stringstream address;
    address << "tcp://localhost:" << port;
    socket_.connect(address.str());
    socket_.subscribe(topic);
    poller_.add(socket_);
}

std::string DynawoReceiver::receive_string() {
    // Polling
    while (!poller_.poll(1000)) {
        std::cout << "DynawoReceiver: Trying to read on topic " + topic_ << std::endl;
    }
    zmqpp::message zmq_message;
    socket_.receive(zmq_message);
    std::string topic;
    std::string message;
    zmq_message >> topic >> message;
    return message;
}

std::vector<double> DynawoReceiver::receive_bytes() {
    // Polling
    while (!poller_.poll(1000)) {
        std::cout << "DynawoReceiver: Trying to read on topic " + topic_ << std::endl;
    }
    zmqpp::message zmq_message;
    socket_.receive(zmq_message);
    std::string topic;
    zmq_message >> topic;

    const void* raw_data_ptr = zmq_message.raw_data(1);
    size_t raw_size = zmq_message.size(1);

    const double* double_data = static_cast<const double*>(raw_data_ptr);
    return std::vector<double>(double_data, double_data + raw_size / sizeof(double));
}
