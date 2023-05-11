fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
	"client.lua",
	"client_menu.lua",
	"config.lua"
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server.js",
	"config.lua",
	"server.lua",
	"servercmds.lua"
}
