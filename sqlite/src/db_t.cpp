#include "db_t.h"

#include <sqlite3.h>

#include <string>
#include <sstream>
#include <cassert>
#include <cstring>

db_t::db_t(const std::string& filename)
    :
        db_(0),
        filename_(filename),
        prepared_insert_statement_(0),
        prepared_select_statement_(0)
{
    int result = sqlite3_open(filename.c_str(), &db_);

    if (result)
    {
        std::stringstream ss;
        ss
            << "Couldn't open database '"
            << filename_
            << "': "
            << sqlite3_errmsg(db_);
        throw ss.str();
    }

    prepare(
        &prepared_insert_statement_,
        "INSERT INTO transactions (cardID, transactionData) "
        "VALUES (?, \""
        "a quick brown fox jumps over the lazy dog "
        "a quick brown fox jumps over the lazy dog "
        "a quick brown fo"
        "\");"
    );

    prepare(
        &prepared_select_statement_,
        "SELECT transactionID FROM transactions WHERE cardID=?;"
    );

    run("PRAGMA cache_size = 1000000;");
}

void db_t::run(const std::string& sql)
{
    char* err_msg = 0;
    int result = sqlite3_exec(
        db_,
        sql.c_str(),
        0,
        0,
        &err_msg
    );
    if (result)
    {
        assert(err_msg);
        std::stringstream ss;
        ss
            << "Couldn't set cache_size on database '"
            << filename_
            << "': "
            << err_msg;

        sqlite3_free(err_msg);

        throw ss.str();
    }
    assert(err_msg == 0);
}

void db_t::prepared_insert(int card_id)
{
    run_prepared(prepared_insert_statement_, card_id);
}

void db_t::prepared_select(int card_id)
{
    run_prepared(prepared_select_statement_, card_id);
}

void db_t::prepare(sqlite3_stmt** statement, const char* sql)
{
    int result = sqlite3_prepare_v2(
        db_,
        sql,
        strlen(sql) * 2, // hack deemed acceptable for this exercise
        statement,
        0
    );

    if (result)
    {
        std::stringstream ss;
        ss
            << "Couldn't created prepared statement from '"
            << sql;
        throw ss.str();
    }
}

void db_t::run_prepared(sqlite3_stmt* statement, int card_id)
{
    int result = sqlite3_bind_int(
        statement,
        1,
        card_id
    );

    if (result)
    {
        std::stringstream ss;
        ss
            << "Couldn't bind prepared statement for card_id = "
            << card_id
            << ".  result = "
            << result;

        throw ss.str();
    }

    do
    {
        result = sqlite3_step(statement);
    } while (result == SQLITE_ROW);

    if (result != SQLITE_DONE)
    {
        std::stringstream ss;
        ss
            << "Couldn't execute prepared statement for card_id = "
            << card_id
            << ".  result = "
            << result;

        throw ss.str();
    }

    result = sqlite3_reset(statement);

    if (result)
    {
        std::stringstream ss;
        ss
            << "Couldn't reset prepared statement for card_id = "
            << card_id
            << ".  result = "
            << result;

        throw ss.str();
    }
}

db_t::~db_t()
{
    sqlite3_finalize(prepared_insert_statement_);
    sqlite3_finalize(prepared_select_statement_);
    sqlite3_close(db_);
}
