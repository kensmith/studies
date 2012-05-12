#ifndef __db_t_h__
#define __db_t_h__

#include <sqlite3.h>

#include <string>

struct db_t
{
    explicit db_t(const std::string& file);
    ~db_t();
    void run(const std::string& sql);

    void prepared_insert(int card_id);
    void prepared_select(int card_id);

private:
    void prepare(sqlite3_stmt** statement, const char* sql);
    void run_prepared(sqlite3_stmt* statement, int card_id);

    db_t(const db_t& rhs);
    db_t& operator=(const db_t& rhs);
    sqlite3* db_;
    std::string filename_;
    sqlite3_stmt* prepared_insert_statement_;
    sqlite3_stmt* prepared_select_statement_;
};

#endif // __db_t_h__
