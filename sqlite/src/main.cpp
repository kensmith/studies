#include "db_t.h"

#include <sqlite3.h>

#include <cassert>
#include <string>
#include <iostream>
#include <sstream>
#include <sys/time.h>
#include <cstdlib>

namespace
{
    int usage(const std::string& argv0)
    {
        std::cerr
            << "usage: "
            << argv0
            << " <sqlite3 db file>"
            << std::endl;

        return 1;
    }

    void bail(const std::string& msg)
    {
        std::cerr
            << "bailed: "
            << msg
            << std::endl;

        std::exit(2);
    }

    inline double timestamp()
    {
        struct timeval tv = {0, 0};
        (void) gettimeofday(&tv, 0);
        return tv.tv_sec + tv.tv_usec / 1e6;
    }

    inline int random_card_id()
    {
       return random() % 40000 + 1;
    }
}

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        assert(argv[0]);
        return usage(argv[0]);
    }

    srandom(static_cast<unsigned long>(timestamp()));

    try
    {
        db_t db(argv[1]);

#if 1
        db.run("PRAGMA synchronous=OFF;");
        db.run("PRAGMA journal_mode=OFF;");
#endif

#if 1
        double start = timestamp();
        db.run("BEGIN TRANSACTION;");
        for (int trans = 0; trans < 1000; ++trans)
        {
            double batch_start = timestamp();
            for (int id = 1; id <= 40000; ++id)
            {
                db.prepared_insert(id);
            }

            int total_trans = 40000 * (trans + 1);
            if (total_trans % 8000000 == 0)
            {
               db.run("END TRANSACTION;BEGIN TRANSACTION;");
            }

            double batch_end = timestamp();
            std::cout
                << total_trans
                << ","
                << (batch_end - batch_start)
                << std::endl;
        }
        db.run("END TRANSACTION");
        double end = timestamp();
        std::cout
            << "inserts took "
            << (end - start)
            << " seconds."
            << std::endl;
#endif

#if 1
        std::cout
            << "vacuuming the db"
            << std::endl;
        double vacuum_start = timestamp();
        db.run("vacuum;");
        double vacuum_end = timestamp();
        std::cout
            << "vacuuming took "
            << (vacuum_end - vacuum_start)
            << " seconds."
            << std::endl;
#endif

#if 1
        std::cout
            << "creating an index on cardID"
            << std::endl;

        double create_index_start = timestamp();
        db.run(
            "CREATE INDEX IF NOT EXISTS idIndex on transactions (cardID);"
        );
        double create_index_end = timestamp();

        std::cout
            << "index creation took "
            << (create_index_end - create_index_start)
            << " seconds."
            << std::endl;
#endif

#if 1
        std::cout
            << "doing selects"
            << std::endl;

        double selects_start = timestamp();
        for (int i = 0; i < 100; ++i)
        {
            double select_start = timestamp();
            int random_id = random_card_id();
            db.prepared_select(random_id);
            double select_end = timestamp();

            std::cout
                << i
                << ","
                << (select_end - select_start)
                << std::endl;
        }
        double selects_end = timestamp();

        std::cout
            << "selects took "
            << (selects_end - selects_start)
            << " seconds."
            << std::endl;
#endif
    }
    catch (const std::string& msg)
    {
        bail(msg);
    }
}
