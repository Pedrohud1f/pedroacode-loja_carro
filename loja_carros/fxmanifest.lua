fx_version "bodacious"
game "gta5"

ui_page "nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server-side/server_utils.lua",
	"server-side/server.lua"
}

files {
	"nui/*",
	"nui/**/*"
}