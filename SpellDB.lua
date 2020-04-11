local _, CsAlert = ...

local spellIds = {}

-- TODO: convert all these to spell IDs
-- Spells that interrupts and prevent spellcasting
spellIds.counterspell = {
    24687,  -- "Aspect of Jeklik",
    2139,   -- "Counterspell",
    10887,  -- "Crowd Pummel",
    8042,   -- "Earth Shock",
    19675,  -- "Feral Charge Effect",
    6730,   -- "Head Butt",
    1766,   -- "Kick",
    6552,   -- "Pummel",
    72,     -- "Shield Bash",
    19244,  -- "Spell Lock"
}

-- Spells that put the target to sleep
spellIds.asleep = {
    9256,   -- "Deep Sleep",
    8040,   -- "Druid's Slumber",
    16798,  -- "Enchanting Lullaby",
    7967,   -- "Naralex's Nightmare",
    700     -- "Sleep"
}

-- Spells that banish the target
spellIds.banish = {
    710,    -- "Banish",
    16451   -- "Judge's Gavel"
}

-- Spells that charms the target
spellIds.charm = {
    6358    -- "Seduction"
}

-- Spells that disorient the target
spellIds.disorient = {
    2094,   -- "Blind",
    26108,  -- "Glimpse of Madness",
    19503   -- "Scatter Shot"
}

-- Spells that cause the target to run in fear
spellIds.fear = {
    26641,  -- "Aura of Fear",
    18431,  -- "Bellowing Roar",
    21330,  -- "Corrupted Fear",
    6789,   -- "Death Coil",
    23275,  -- "Dreadful Fright",
    5782,   -- "Fear",
    25815,  -- "Frightening Shriek",
    5484,   -- "Howl of Terror",
    16508,  -- "Intimidating Roar",
    5246,   -- "Intimidating Shout",
    19577,  -- "Intimidation",
    19408,  -- "Panic",
    3109,   -- "Presence of Death",
    8122,   -- "Psychic Scream",
    21869,  -- "Repulsive Gaze",
    8225,   -- "Run Away!",
    7399,   -- "Terrify",
    8715,   -- "Terrifying Howl",
    14100,  -- "Terrifying Roar",
    6605,   -- "Terrifying Screech",
    21898,  -- "Warlock Terror",
    25260   -- "Wings of Despair"
}

-- Spells that incapacitate the target
spellIds.incapacitate = {
    1776,   -- "Gouge",
    22570,  -- "Mangle",
    13327,  -- "Reckless Charge",
    20066,  -- "Repentance",
    6770    -- "Sap"
}

-- Spells that mind controls the target
spellIds.mindcontrol = {
    12888,  -- "Cause Insanity",
    7645,   -- "Dominate Mind",
    13180,  -- "Gnomish Mind Control Cap",
    605,    -- "Mind Control",
    19469   -- "Poison Mind"
}

-- Spells that polymorph the target
spellIds.polymorph = {
    17738,  -- "Curse of the Plague Rat",
    22274,  -- "Greater Polymorph",
    11641,  -- "Hex",
    118,    -- "Polymorph",
    23603   -- "Wild Polymorph"
}

-- Spells that root the target
spellIds.root = {
    10852,  -- "Battle Net",
    113,    -- "Chains of Ice",
    5424,   -- "Claw Grasp",
    4246,   -- "Clenched Pinchers",
    19306,  -- "Counterattack",
    5219,   -- "Draw of Thistlenettle",
    8377,   -- "Earthgrab",
    11820,  -- "Electrified Net",
    4962,   -- "Encasing Webs",
    22994,  -- "Entangle",
    339,    -- "Entangling Roots",
    19185,  -- "Entrapment",
    15471,  -- "Enveloping Web",
    24110,  -- "Enveloping Webs",
    19675,  -- "Feral Charge Effect",
    10017,  -- "Frost Hold",
    122,    -- "Frost Nova",
    12494,  -- "Frostbite",
    8142,   -- "Grasping Vines",
    14030,  -- "Hooked Net",
    11264,  -- "Ice Blast",
    22519,  -- "Ice Nova",
    23694,  -- "Improved Hamstring",
    19229,  -- "Improved Wing Clip",
    5567,   -- "Miring Mud",
    8346,   -- "Mobility Malfunction",
    3542,   -- "Naraxis Web",
    6533,   -- "Net",
    13138,  -- "Net-o-Matic",
    23414,  -- "Paralyze",
    22935,  -- "Planted",
    22707,  -- "Root",
    7761,   -- "Shared Bonds",
    7295,   -- "Soul Drain",
    17333,  -- "Spider's Kiss",
    8312,   -- "Trap",
    745,    -- "Web",
    16469,  -- "Web Explosion",
    12252,  -- "Web Spray",
    24170,  -- "Whipweed Entangle"
    24152   -- "Whipweed Roots"
}

-- Spells that silence the target
spellIds.silence = {
    19821,  -- "Arcane Bomb",
    16838,  -- "Banshee Shriek",
    18469,  -- "Counterspell - Silenced",
    3589,   -- "Deafening Screech",
    18425,  -- "Kick - Silenced",
    6942,   -- "Overwhelming Stench",
    12946,  -- "Putrid Stench",
    7074,   -- "Screams of the Past",
    9552,   -- "Searing Flames",
    18498,  -- "Shield Bash - Silenced",
    15487,  -- "Silence",
    23918,  -- "Sonic Burst",
    19393,  -- "Soul Burn",
    19244   -- "Spell Lock"
}

-- Spells that stun the target
spellIds.stun = {
    24690,  -- "Aspect of Arlokk",
    24686,  -- "Aspect of Mar'li",
    6466,   -- "Axe Toss",
    6253,   -- "Backhand",
    5211,   -- "Bash",
    4067,   -- "Big Bronze Bomb",
    4069,   -- "Big Iron Bomb",
    15268,  -- "Blackout",
    17293,  -- "Burning Winds",
    7922,   -- "Charge Stun",
    6409,   -- "Cheap Shot",
    6945,   -- "Chest Pains",
    12809,  -- "Concussion Blow",
    16096,  -- "Cowering Roar",
    5403,   -- "Crash of Waves",
    17286,  -- "Crusader's Hammer",
    5106,   -- "Crystal Flash",
    3635,   -- "Crystal Gaze",
    3636,   -- "Crystalline Slumber",
    16104,  -- "Crystallize",
    19784,  -- "Dark Iron Bomb",
    18395,  -- "Dismounting Shot",
    21152,  -- "Earthshaker",
    25189,  -- "Enveloping Winds",
    7139,   -- "Fel Stomp",
    13902,  -- "Fist of Ragnaros",
    15743,  -- "Flamecrack",
    28323,  -- "Flameshocker's Revenge",
    28314,  -- "Flameshocker's Touch",
    16803,  -- "Flash Freeze",
    5276,   -- "Freeze",
    11836,  -- "Freeze Solid",
    17011,  -- "Freezing Claw",
    3355,   -- "Freezing Trap Effect",
    3143,   -- "Glacial Roar",
    13237,  -- "Goblin Mortar",
    12734,  -- "Ground Smash",
    19364,  -- "Ground Stomp",
    6524,   -- "Ground Tremor",
    6982,   -- "Gust of Wind",
    853,    -- "Hammer of Justice",
    19780,  -- "Hand of Ragnaros",
    6730,   -- "Head Butt",
    14102,  -- "Head Smash",
    12543,  -- "Hi-Explosive Bomb",
    20683,  -- "Highlord's Justice",
    11264,  -- "Ice Blast",
    16869,  -- "Ice Tomb",
    12355,  -- "Impact",
    20253,  -- "Intercept Stun",
    4068,   -- "Iron Grenade",
    408,    -- "Kidney Shot",
    20276,  -- "Knockdown",
    6266,   -- "Kodo Stomp",
    4065,   -- "Large Copper Bomb",
    25852,  -- "Lash",
    10856,  -- "Link Dead",
    13808,  -- "M73 Frag Grenade",
    5530,   -- "Mace Stun Effect",
    17500,  -- "Malown's Slam",
    12421,  -- "Mithril Frag Bomb",
    3609,   -- "Paralyzing Poison",
    11020,  -- "Petrify",
    9005,   -- "Pounce",
            -- "Psychic Scream",
            -- Need to figure out how to differentiate between the two effects
    18093,  -- "Pyroclasm",
    19641,  -- "Pyroclast Barrage",
    8285,   -- "Rampage",
    3446,   -- "Ravage",
    12798,  -- "Revenge Stun",
    6304,   -- "Rhahk'Zor Slam",
    4064,   -- "Rough Copper Bomb",
    17276,  -- "Scald",
    6927,   -- "Shadowstalker Slash",
    5918,   -- "Shadowstalker Stab",
    8242,   -- "Shield Slam",
    3551,   -- "Skull Crack",
    11430,  -- "Slam",
    4066,   -- "Small Bronze Bomb",
    6435,   -- "Smite Slam",
    8817,   -- "Smoke Bomb",
    24671,  -- "Snap Kick",
    16922,  -- "Starfire Stun",
            -- "Stomp",
            -- There's another spell named Stomp that causes a slow effect instead
    20685,  -- "Storm Bolt",
    19136,  -- "Stormbolt",
    56,     -- "Stun",
    16497,  -- "Stun Bomb",
    21188,  -- "Stun Bomb Attack",
    5648,   -- "Stunning Blast",
    15283,  -- "Stunning Blow",
    5703,   -- "Stunning Strike",
    5708,   -- "Swoop",
    23364,  -- "Tail Lash",
    12562,  -- "The Big One",
    19769,  -- "Thorium Grenade",
    21748,  -- "Thorn Volley",
    16075,  -- "Throw Axe",
    8150,   -- "Thundercrack",
    7803,   -- "Thundershock",
    835,    -- "Tidal Charm",
    21990,  -- "Tornado",
    3263,   -- "Touch of Ravenclaw",
    20549,  -- "War Stomp",
    24600,  -- "Web Spin",
    6749    -- "Wide Swipe"
}

-- Convert spell IDs to names (ensures the names match the locale)
CsAlert.spellTypeDb = {}
CsAlert.spellList = {}
for spellType, spells in pairs(spellIds) do
    CsAlert.spellTypeDb[spellType] = {}
    for _, spellId in ipairs(spells) do
        local spellName = GetSpellInfo(spellId)
        CsAlert.spellTypeDb[spellType][spellName] = true
        CsAlert.spellList[spellName] = true
    end
end
