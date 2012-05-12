#include <fstream>
#include <sstream>

#define basename "typeelmt"
#define ttf_name basename ".ttf"
#define hpp_name basename ".hpp"
#define cpp_name basename ".cpp"

struct null_converter_t
{
    std::string initialize()
    {
        return "";
    }
    std::string operator()(const char c)
    {
        return std::string(1, c);
    }
    std::string finalize()
    {
        return "";
    }
};

static const char * lut[] = {
    "0", "1", "2", "3",
    "4", "5", "6", "7",
    "8", "9", "a", "b",
    "c", "d", "e", "f",
};
struct asciify_t
{
    asciify_t()
        : num_bytes_processed_(0)
    {
    }
    std::string initialize()
    {
        std::stringstream ss;
        ss
            << "#include \""
            << hpp_name
            << "\"\n"
            << "\n"
            << "const char * "
            << basename
            << " =\n"
            << "{\n";

        return ss.str();
    }
    std::string operator()(const char c)
    {
        std::stringstream ss;
        if (num_bytes_processed_ % 16 == 0)
        {
            ss << "    \"";
        }
        ss << "\\x";
        ss << std::string(lut[(c >> 4) & 0xf]);
        ss << std::string(lut[c & 0xf]);
        if (++num_bytes_processed_ % 16 == 0)
        {
            ss << "\"\n";
        }

        return ss.str();
    }
    std::string finalize()
    {
        std::stringstream ss;
        if (num_bytes_processed_ % 16 != 0)
        {
            ss << "\"";
        }
        ss << "\n};";

        return ss.str();
    }
private:
    int num_bytes_processed_;
};

typedef asciify_t converter_t;

int main()
{
    {
        std::ifstream in(ttf_name);
        std::ofstream source(cpp_name);
        char c;
        converter_t converter;
        source << converter.initialize();
        while (in.get(c) && !in.eof()) {
            source << converter(c);
        }
        source << converter.finalize();
    }

    {
        std::ofstream header(hpp_name);
        header
            << "#pragma once\n"
            << "\n"
            << "extern const char * "
            << basename
            << ";\n";
    }
}
