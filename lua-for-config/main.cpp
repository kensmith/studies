#include <iostream>
#include <lua.hpp>
#include <assert.h>

int main()
{
    // Traverse the table
    lua_State* L = luaL_newstate();
    assert(!luaL_dofile(L, "conf.lua"));

    lua_getglobal(L, "conf");
    lua_getfield(L, lua_gettop(L), "general");
    lua_getfield(L, lua_gettop(L), "language");
    const char* language = lua_tostring(L, lua_gettop(L));
    lua_pop(L, 2);

    lua_getfield(L, lua_gettop(L), "strings");
    lua_getfield(L, lua_gettop(L), "string00001");
    const char* string00001 = lua_tostring(L, lua_gettop(L));
    lua_pop(L, 1);
    lua_getfield(L, lua_gettop(L), "string00002");
    const char* string00002 = lua_tostring(L, lua_gettop(L));
    lua_pop(L, 1);
    lua_getfield(L, lua_gettop(L), "string00003");
    const char* string00003 = lua_tostring(L, lua_gettop(L));

    std::cout << "language = " << language << std::endl;
    std::cout << "string00001 = " << string00001 << std::endl;
    std::cout << "string00002 = " << string00002 << std::endl;
    std::cout << "string00003 = " << string00003 << std::endl;
}
