-- ItemID Localization File
-- Version 1.7.1

ITEMID_TITLE = "ItemID";
ITEMID_VERSION = "Version";
ITEMID_NOWLOADED = "is now loaded!";
ITEMID_ERROR = "Error";

ITEMID_ITEMID = "The ItemID for ";
ITEMID_ITEMIDFULL = "The full ItemID for ";
ITEMID_ITEMIDSTRING = "The ItemID link string for ";
ITEMID_IMAGE = "The Image for ";
ITEMID_ITEMLINK = "Here is the Link for your item: ";
ITEMID_IS = " is ";
ITEMID_SPELLID = "The SpellID for ";
ITEMID_ENCHANTID = "The EnchantID for ";
ITEMID_ACHIEVEMENT = "The AchievementID for ";
ITEMID_QUEST = "The QuestID for ";
ITEMID_TALENT = "The TalentID for ";
ITEMID_TRADE = "The TradeID for ";
ITEMID_ANDQUESTLEVELIS = " and the Quest Level is ";
ITEMID_SPELLLINK = "Here is the Link for your spell: ";
ITEMID_ACHIEVEMENTLINK = "Here is the Link for your achievement: ";

-- Errors
ITEMID_LINKINVALID = "The link provided was either invalid, or referenced an item or enchant that your system has not yet seen. If it is a Spell, then it is not in your Spellbook.";
ITEMID_IDINVALID = "The ID provided was either invalid, or referenced an item, spell or enchant that your system has not yet seen.";
ITEMID_CMDINVALID = "ItemID experienced an error while parsing your input. Did you even link something?";
ITEMID_MODENOTFOUND = "Could not determine the proper mode."
ITEMID_NOENCHANTIMAGE = "EnchantIDs do not have images.";
ITEMID_NOQUESTIMAGE = "QuestIDs do not have images.";
ITEMID_NOTAVAILABLEINTHISVERSION = "This functionality is not available in your current version of World of Warcraft.";

-- Output Channels
ITEMID_CHAN_PARTY = "party";
ITEMID_CHAN_GUILD = "guild";
ITEMID_CHAN_SAY = "say";
ITEMID_CHAN_YELL = "yell";
ITEMID_CHAN_RAID = "raid";

-- Commandline stuff
ITEMID_CMD_SEPERATOR = " "; -- used to seperate commands, such as "full say", where the space would be the seperator.

ITEMID_MODE_FULL = "full";
ITEMID_MODE_STRING = "string";
ITEMID_MODE_IMAGE = "image";
ITEMID_MODE_ILINK = "itemlink";
ITEMID_MODE_SLINK = "spelllink";
ITEMID_MODE_ALINK = "achievementlink";

ITEMID_HELP = "help";

ITEMID_HELP1 = "Type \"/itemid \" then shift-click the item, then hit enter, and the Item ID will be displayed.";
ITEMID_HELP2 = "  Adding \"full\" first, will make it display the full ItemID. This ID will give you all the enchants, jems, and all the other little details that flesh out your item.";
ITEMID_HELP3 = "  Adding \"string\" first, will make it display the Item Link string. Note: This is incompatible with the Full command!";
ITEMID_HELP4 = "  You can also reverse it's ability by typing \"link\", then typing in an ItemID to get a link! Note: This only works if your system has already seen the item.";
ITEMID_HELP5 = "  Using \"image\" will tell you exactly which image the item uses, including the path.";
ITEMID_HELP6 = "  You can have it said if you add \"say\" before the item. Other values (yell, party, guild, raid) will also work. This is added after \"full\", \"string\", \"image\" or \"link\".";
