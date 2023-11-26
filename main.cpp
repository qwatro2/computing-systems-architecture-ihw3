#include<fstream>
#include<iostream>
#include<iterator>
#include<string>

template<typename T>
void print_array(T* array, int size) {
    for (auto i = 0; i < size; ++i) {
        std::cout << array[i] << ' ';
    }
    std::cout << '\n';
}

struct Data {
    int current_output_index;
    const int n;

    char last_char(char* a) { return a[current_output_index - 1]; }
    bool found() { return n == current_output_index; }
};

int read_to_buffer(std::fstream &stream, char* buffer, int buffer_size) {
    stream.read(buffer, buffer_size);

    if (!stream) {
        buffer_size = stream.gcount();
    }
    
    return buffer_size;
}

Data* iteration(char* buffer, int buffer_size, char* output, int n) {
    auto data = new Data { 1, n };

    output[0] = buffer[0];

    for (auto i = 1; i < buffer_size; ++i) {
        if (buffer[i] < data->last_char(output)) {
            output[data->current_output_index++] = buffer[i];

            if (data->found()) {
                return data;
            }
        } else {
            output[0] = buffer[i];
            data->current_output_index = 1;
        }
    }

    return data;
}

void iteration(char* buffer, int buffer_size, char* output, Data* data) {
    for (auto i = 0; i < buffer_size; ++i) {
        if (buffer[i] < data->last_char(output)) {
            output[data->current_output_index++] = buffer[i];

            if (data->found()) {
                return;
            }
        } else {
            output[0] = buffer[i];
            data->current_output_index = 1;
        }
    }
}

std::pair<bool, char*> solution(std::fstream &stream, char* buffer, int buffer_size, int n) {  // return index of beginning this sequance, or -1 if not exists
    auto output_buffer = new char[n];
    int read_chars = read_to_buffer(stream, buffer, buffer_size);
    auto data = iteration(buffer, read_chars, output_buffer, n);

    if (data->found()) {
        delete data;
        return std::make_pair(true, output_buffer);
    }

    for (auto i = 0; stream && i < 20; ++i) {
        read_chars = read_to_buffer(stream, buffer, buffer_size);
        iteration(buffer, read_chars, output_buffer, data);
        if (data->found()) {
            delete data;
            return std::make_pair(true, output_buffer);
        }
    }

    delete data;
    return std::make_pair(false, output_buffer);
}

int main() {
    constexpr int buffer_size = 10;
    auto buffer = new char[buffer_size];

    int n;
    std::cin >> n;
    
    std::fstream input("input");

    auto result = solution(input, buffer, buffer_size, n);

    std::fstream output("output");
    if (result.first) {
        output << result.second;
    } else {
        output << "not exists";
    }


    output.close();
    input.close();
    delete[] buffer;
    delete[] result.second;
    return 0;
}
