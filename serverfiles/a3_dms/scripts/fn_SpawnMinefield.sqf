/*
	DMS_fnc_SpawnMinefield
	Created by eraser1
	
	Usage:
	[
		_centerPos,						// ARRAY: Position to spawn the minefield around
		_difficulty,					// STRING or ARRAY: The "difficulty" level of the minefield. Determines the number of mines and the radius it spawns at. String refers to a difficulty set in config, array is defined as [_mineCount,_radius];
		_side,							// STRING: The "side" for which the mines should spawn. The spawned mines will be revealed to the AI so they don't run into it.
		_spawnWarningSign,				// (OPTIONAL) BOOL: Whether or not to spawn the warning signs around the minefield (at maximum radius + 2 meters)
		_mineClassname					// (OPTIONAL) STRING: The classname of the mine to spawn.
	] call DMS_fnc_SpawnMinefield;
*/

private ["_centerPos", "_difficulty", "_side", "_mines", "_minesInfo", "_AISide", "_mineCount", "_radius", "_randDirOffset", "_sign"];


_mines = [];

if (DMS_SpawnMinesAroundMissions) then
{
	_OK = params
	[
		["_centerPos","",[[]],[2,3]],
		["_difficulty","",["",[]],[2]],
		["_side","",[""]]
	];

	if (!_OK) exitWith
	{
		diag_log format ["DMS ERROR :: Calling DMS_fnc_SpawnMinefield with invalid parameters: %1",_this];
	};

	_spawnWarningSign	= DMS_SpawnMineWarningSigns;
	_mineClassname		= "ATMine";
	if ((count _this)>3) then
	{
		_spawnWarningSign = param [3,DMS_SpawnMineWarningSigns,[true]];

		if ((count _this)>4) then
		{
			_mineClassname = param [4,"ATMine",[true]];
		};
	};


	if !(getText (configfile >> "CfgVehicles" >> _mineClassname >> "vehicleClass") isEqualTo "Mines") exitWith
	{
		diag_log format ["DMS ERROR :: Calling DMS_fnc_SpawnMinefield with invalid _mineClassname: %1 | _this: %2",_mineClassname, _this];
	};


	_minesInfo = _difficulty;
	if ((typeName _difficulty)=="STRING") then
	{
		_minesInfo	= missionNamespace getVariable [format ["DMS_MineInfo_%1", _difficulty], [10,50]];
	};

	_AISide		= missionNamespace getVariable [format ["DMS_%1Side", _side], EAST];


	_mineCount	= _minesInfo select 0;
	_radius		= _minesInfo select 1;


	for "_i" from 1 to _mineCount do
	{
		private ["_minePos", "_mine"];

		_minePos = [_centerPos,random _radius,random 360] call DMS_fnc_SelectOffsetPos;
		_mine = createMine ["ATMine", [0,0,0], [], 0];

		// Fixes players shooting the mine and causing premature 'splosions
		if (DMS_BulletProofMines) then
		{
			_mine allowDamage false;
		};

		//In case you're using directional mines such as tripwires/SLAMs
		_mine setDir (random 360);
		_mine setPosATL _minePos;

		_AISide revealMine _mine;


		_mines pushBack _mine;
	};

	if (_spawnWarningSign) then
	{
		_randDirOffset = random 45;
		for "_i" from 0 to 359 step 90 do
		{
			_sign = createVehicle ["Land_Sign_Mines_F", [0,0,0], [], 0, "CAN_COLLIDE"];
			_sign setDir (180+_i);
			_sign setPosATL ([_centerPos, _radius+2, _randDirOffset+_i] call DMS_fnc_SelectOffsetPos);
			_sign setVectorUp [0,0,1];

			// _mines array is for only cleanup atm, so just add them to the list
			_mines pushBack _sign;
		};
	};

	if (DMS_DEBUG) then
	{
		(format ["SpawnMinefield :: Spawned %1 mines around %2 with _minesInfo: %3 | Warning signs spawned: %5 | _mines: %4",_mineCount,_centerPos,_minesInfo,_mines,_spawnWarningSign]) call DMS_fnc_DebugLog;
	};
};



_mines