VS_PoliceMod.SQL = VS_PoliceMod.SQL or {}

-- do you use mysql?
VS_PoliceMod.SQL.UseMySQL = false

-- leave this how it is if you're not using MySQL
VS_PoliceMod.SQL.Credentials = {
    IP = "127.0.0.1",
    Username = "root",
    Password = "root",
    Database = "",
    Port = "",
    Socket = "",
}
--

--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--
--
-- DO NOT TOUCH ANYTHING BELOW
--

local tblColors = {
    ["error"] = Color(255, 0, 0),
    ["success"] = Color(0, 255, 0),
}

function VS_PoliceMod.SQL:Print(sType, sMessage)
    if not tblColors[sType] then sType = "error" end
    MsgC(tblColors[sType], "[Advanced Police Mod - SQL] " .. sMessage .. "\n")
end

-- Initializes the mysql connection with the date given in the config.
function VS_PoliceMod.SQL:InitSQL()
	self.connected = false
	
	if self.UseMySQL then
		require("mysqloo")

		self.db = mysqloo.connect(self.Credentials.IP, self.Credentials.Username, self.Credentials.Password, self.Credentials.Database, self.Credentials.Port, self.Credentials.Socket)

		function self.db.onConnected(db)
			self.connected = true
			self:Print("success", "MySQL connection successfull")

			db:setCharacterSet("utf8mb4")

			self:OnConnected()
		end
				
		function self.db.onConnectionFailed(db, err)
			VS_PoliceMod.SQL:Print("error", "MySQL connection failure: " .. err)
		end

		self.db:connect()
	else
		self:Print("success", "Using SQLite as data provider")
		self.connected = true
		
		self:OnConnected()
	end
end

-- Escapes the given string so that it is safe to use in a query.
function VS_PoliceMod.SQL:EscapeString(string)
	if self.UseMySQL then
		return "'" .. self.db:escape(string) .. "'"
	else
		return sql.SQLStr(string, false)
	end
end

-- Executes the sql string and executes the callback afterwards.
-- Because sqlite does not support prepared statements, we have our own escape mechanism.
-- You can give a params table and the sql string can include them with %index%.
-- c37c5fd06179e2193865809bcee838ea5a24aa15cbd0472ef7a40b7d90b6c0b3
-- So %1% refers to the escaped version of the first index of the params table.
-- Note that because supporting sqlite and mysql, we should only execute statements supported by both systems.
-- For sqlite AUTO_INCREMENT gets replaced to AUTOINCREMENT and INSERT IGNORE gets replaced to INSERT OR IGNORE.
function VS_PoliceMod.SQL:Query(sqlString, params, callback)
	if !self.connected then
		self:Print("error", "Tried to execute query with no database object being connected")
		return
	end

	-- Allow to skip the params parameter.
	if isfunction(params) then
		callback = params
		params = nil
	end

	if params ~= nil then
		-- Allow to pass scalar types.
		if !istable(params) then
			params = { params }
		end

		for k, v in pairs(params) do
			sqlString = string.Replace(sqlString, "%" .. k .. "%", self:EscapeString(tostring(v)))
		end
	end

	if self.UseMySQL then
		local query = self.db:query(sqlString)

		function query.onAborted(query)
			if callback then
				callback(false)
			end
		end

		function query.onSuccess(query, data)
			if callback then
				callback(true, data)
			end
		end

		function query.onError(query, error)
			VS_PoliceMod.SQL:Print("error", "Error while executing query:\n" .. error .. "\n\nQuery:\n" .. sqlString)
		end

		query:start()
	else
		-- Convert mysql syntax to sqlite syntax.
		sqlString = string.Replace(sqlString, "AUTO_INCREMENT", "AUTOINCREMENT")
		sqlString = string.Replace(sqlString, "INSERT IGNORE", "INSERT OR IGNORE")

		local data = sql.Query(sqlString)

		if data == false then
			self:Print("error", "Error while executing query:\n" .. sql.LastError() .. "\n\nQuery:\n" .. sqlString)

			if callback then
				callback(false)
			end
		else
			-- To match mysqloo behavior: Return an empty table when there is no result. 76561198281234240
			if data == nil then
				data = {}
			end

			if callback then
				callback(true, data)
			end
		end
	end
end

hook.Add("InitPostEntity", "VS_PoliceMod.SQL:InitPostEntity", function()
    VS_PoliceMod.SQL:InitSQL()
end)

function VS_PoliceMod.SQL:OnConnected()
	VS_PoliceMod.SQL:Query([[CREATE TABLE IF NOT EXISTS `vs_policemod_complaints` (
		`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
		`citizen` VARCHAR(255),
		`category` VARCHAR(255),
		`content` TEXT,
		`state` INT(1) DEFAULT '0'
	);]])

	VS_PoliceMod.SQL:Query("UPDATE `vs_policemod_complaints` SET state = 1 WHERE state = 0;")
	
	VS_PoliceMod.SQL:Query([[CREATE TABLE IF NOT EXISTS `vs_policemod_logs` (
		`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
		`steamid` VARCHAR(20),
		`category` VARCHAR(255),
		`content` TEXT,
		`date` INT(11)
	);]])
end