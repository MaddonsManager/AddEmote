AddEmote README
version 2.2.2

Ever wished World of Warcraft had more emotes?  Or wanted to create 
your own emotes that you could use like the regular ones?  Well, now you 
can!  AddEmote lets you easily create new /command emotes for all your
characters.

Here's how you'd do it:

/addemote chinrub rubs his chin thoughtfully.

Having done that, you can then do:

/chinrub

and your character (we'll call him Alistair) would emote:

Alistair rubs his chin thoughtfully.

Wait... you say not all your characters are male?  That's okay, we can
handle that.  AddEmote includes ChatSubs, which lets you use "substitution
strings" that will automatically be changed depending on your character
(or your target, but we'll get to that).  So, let's make that:

/addemote chinrub rubs <hisher> chin thoughtfully.

The <hisher> will become either "his" or "her", depending on whether the 
character you're playing is male or female.

/chinrub
Alistair rubs his chin thoughtfully.
(log out, log onto Becca)
/chinrub
Becca rubs her chin thoughtfully.

Here's some more substitution strings:

<target>  	- Your target's name, or "everyone" if you have no target.
<player>  	- Your character's name.
<targetheshe> 	- "he", "she", or "it", based on the target's sex.
<heshe> 	- "he", "she", or "it", based on your character's sex.

See the "Substitution Strings" section below for full details, or the 
ChatSubs README.

You can also put multiple choices for an emote, and AddEmote will 
randomly choose one.  To do this, put a vertical bar (| - also called
the pipe symbol) between the choices.  For example:

/addemote chinrub rubs his chin thoughtfully.|rubs his chin, thinking.

You can use substitution strings in these, and AddEmote will attempt to
filter out the alternatives that can't be filled in.  For example:

/addemote eyeroll rolls <hisher> eyes at <target>.|rolls <hisher> eyes.

If you have a target, /eyeroll will do the version with a target; if 
you don't, it will do the version without a target.

Getting a little more complicated, 

/addemote pethungry 's pet <pet> looks at <target> and licks <pethisher> chops.|'s pet <pet> looks around for something to eat.|says, "Oh, heck, my pet ran off.  It must be hungry."

Here, if you have a pet our and have a target, it'll do the first one; 
if you have a pet out but don't have a target, it'll do the second; and
if you don't have a pet out at all, it'll do the third one.

Lastly, you can define an emote with <text> in it, and any extra text 
you give with the emote will be inserted where the <text> is.  For 
example:

/addmote ps 's <pettype> <pet> says, "<text>"
/ps What?  You've never seen a talking cat?
Hunterjoe's cat Backbiter says, "What?  You've never seen a talking cat?"


Substitution Strings
--------------------

There's a lot you can do with substitution strings.  Here's a couple
of simple examples:

/addemote introduce says, "Pleased to meet you, <target>.  I am <player>."
/target noobkiller
/introduce
Becca says, "Pleased to meet you, Noobkiller.  I am Becca."

/addemote blamepoint points at <target>.  "Don't blame me -- <targetheshe> did it!"
/blamepoint
Becca points at Noobkiller.  "Don't blame me -- he did it!"

Substitution strings are of the form <whowhat>, where:

who is:

target 
player
focus
pet

(player is assumed if you don't give any of these)

what is:

name
class
race
level
sex
type (pet type -- voidwalker, imp, wolf, cat, etc.)
heshe 
himher
hisher
hishers
mark (raid mark)
health (current health as a percentage)
pvp ("flagged" or "unflagged")
position (always your map position, since WoW won't let you know anyone else's)

"name" is assumed if you don't give any of these.  You can leave out either this
or "player", so:

<playername>
<player>
<name>

are all equivalent.

If the first letter of the "what" is capitalized, the output will have 
the first letter capitalized (except for names, which are always as 
they are in the game).  Thus:

<Heshe> 

will give "He" or "She", depending on your character's sex.  Whether other 
letters are capitalized or not doesn't matter.  <Heshe>, <HeShe>, and <HESHE>
all do the same thing.

(For users of the previous versions, the old substitution strings 
(%tc, %p, %pp, etc.) still work.)


More examples:

/addemote dontlook doesn't want you to look at <himher>.
/dontlook
Becca doesn't want you to look at her.

/addemote lookat points at %t.  "Look at %to!"
/lookat
Becca points at Noobkiller.  "Look at him!"


A name will come out as "everyone" if you don't have a target, so you
can do emotes like:

/addemote chuckle chuckles at <target>.
(targets no one)
Becca chuckles at everyone.
/target Noobkiller
Becca chuckles at Noobkiller.

If you want something different, you can simply separate an alternative
that doesn't involve a target with a vertical bar character (|), like
this:

/addemote chuckle chuckles at <target>.|chuckles to <himher>self.

/addemote classsnob wouldn't expect any better from a <targetclass> like <target>.
/classsnob
Becca wouldn't expect any better from a warlock like Noobkiller.

/addemote racesnob says, "I wouldn't expect any better from a <targetrace>."
/racesnob
Becca says, "I wouldn't expect any better from a troll."

/addemote accuse points to <target> and calls out, "<targetHimher>!  <targetHeShe>'s the one!"
/accuse
Becca points to Noobkiller and calls out, "Him!  He's the one!"

/charemote defines a character-specific emote -- one that only exists for 
the character you're playing when you define it.  If you have a /addemote
and a /charemote both with the same name, the /charemote is the one that
will be used.  Otherwise, it works the same as /addemote.

/charemote lookat stares at <target>.
/lookat
Becca stares at everyone.
(logs out, logs in on Alistair)
/target noobkiller
/lookat
Alistair points at Noobkiller.  "Look at him!"
(since lookat was defined with a /addemote earlier, Alistair gets that 
version, but Becca has her own now)

If you want to change an emote you've created, you can simply do 
/addemote again with the same emote name.  (Or /charemote again, if
it was defined /charemote.)

/addemote sob sobs.
/sob
Becca sobs.
/addemote sob sobs on <target>'s shoulder.
/sob
Becca sobs on Noobkiller's shoulder.

To remove an emote, use /delemote with the emote name:

/delemote sob
/sob
(Does nothing)

If both a character-specific emote and a global one exist, the 
character-specific one will be removed.

/listemotes will list the emotes you have defined in your chat window.

/showemote emotename 
will show you the string that's set up for "emotename".


Notes and Caveats
-----------------

Blizzard's chat engine handles the Blizzard-supplied emotes before 
checking for addon-added commands.  Thus, while you can define an 
emote with the same name as one of the existing ones, it won't actually
work.

AddEmote-created emotes require you to actually target someone to for
the %t functionality to work -- you can't do this:

/myemote johndoe

-- you have to actually target johndoe, then do /myemote.

You can create an emote with the same /command as one added by an addon.  
Blizzard's way of handling this doesn't guarantee what will happen -- you
might get the addon's command, you might get the emote.  I'd recommend
avoiding it.  If you do it by accident, you can use /delemote to remove 
the emote; it won't remove the other addon's /command.

If you provide alternatives, and *none* of them have all the needed units present, then AddEmote will simply choose one randomly anyway.