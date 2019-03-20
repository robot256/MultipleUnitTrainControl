# MultipleUnitTrainControl
Factorio mod written in Lua.  Lets locomotives provide backwards force in automatic if they are in a bidirectional pair.


Type: Mod
Name: Multiple Unit Train Control
Description: Lets locomotives provide backwards force in automatic if they are in a bidirectional pair.
License: MIT
Source: GitHub
Download: mods.factorio.com
Version: 0.1.1
Release: 2019-03-19
Tested-With-Factorio-Version: 0.17.16
Category: Helper, Train
Tags: Train

Have you ever wished that all your locomotives would provide acceleration when running automatically, not just the ones facing forwards?  You're not alone!  With the power of Multiple Unit Train Control (MU Control) technology, a coupled pair of locomotives (an MU consist) can drive in either direction using the power of both!

[size=150]Summary[/size]
Simply take two locomotives of the same type and couple them with their backs facing each other.  Now you have an MU consist of two locomotives that can drive in either direction with the force of two locomotives.  It will also consume fuel at the rate of two locomotives.  Couple multiple MU consists together to get even more motive power for your longest trains, or put one on each end to improve air resistance in both directions without sacrificing power.

This mod is meant to be an alternative to [url=https://mods.factorio.com/mod/Noxys_Multidirectional_Trains]Noxy's Multidirectional Trains[/url].  I created it specifically to work with the [url=https://mods.factorio.com/mod/Automatic_Coupling_System]Automatic Coupling System[/url] mod, because constantly uncoupling, reversing, and recoupling the trains interferes with the train alignment required to do realistic yard switching.  MU Control only modifies the train when the locomotives are first linked, so it doesn't change anything while coupling and uncoupling wagons automatically.

[size=150]Details[/size]
Under the hood, MU Control detects when a train is created with back-to-back locomotives of the same type, and silently replaces them with a different entity, the "MU version", that have twice as much power as before.  As long as those two locomotives do not separate, MU Control never changes the train again.  If an MU locomotive is found to be without its twin, MU Control will immediately replace it with the normal version.

Since the game still thinks only one locomotive is driving, but with twice the power, the front locomotive will use twice as much fuel and the back won't use any.  MU Control automatically balances fuel between them periodically, so the single-direction range of the two together is the same as if they were both facing forward.  You can set the frequency of balancing or disable it in the mod settings.  If you let it drain to empty, it won't balance the last unit of fuel.

[size=150]Features[/size]
[list]
[*]Upgrading and downgrading locomotives preserves color, name, health, fuel inventory, burner heat, and train schedule.
[*]Correctly detects when the player uncouples locomotives of an MU consist.
[*]Pressing 'Q' over an MU version will correctly select its normal version from your inventory.
[*]Mod setting to turn off MU Control (reverts all MU locomotives to normal).
[*]Mod setting to configure frequency for fuel balancing.
[*]Currently supports: Vanilla, [url=https://mods.factorio.com/mods/Optera/TrainOverhaul]Train & Fuel Overhaul[/url]
[/list]

[size=150]Planned Features[/size]
[list]
[*]Preserve contents of locomotive equipment grids on replacement.
[*]Support additional modded locomotives, especially [url=https://mods.factorio.com/mod/Realistic_Electric_Trains]Realistic Electric Trains[/url].
[*]Add MU Control as a research technology.
[*]Add support for linking pairs locomotives that are not directly coupled to each other. This would be another level of technology (Radio-Controlled Multiple Units).
[/list]

[size=150]Known Issues[/size]
[list]
[*]When installing, enabling, or disabling the mod on an existing map, trains that are moving across an intersection during the upgrade will be disconnected and may be damaged/destroyed by the rest of their train.
[*]The MU version of each locomotive type is not craftable and should never end up in your inventory, but sometimes it does. It will revert as soon as you place it on a track.
[*]Making a blueprint of an MU version will keep the MU version in the blueprint, and you'll never be able to build that part of the blueprint. You could disable MU Control temporarily (reverts all MU locomotives immediately), make the blueprint, then re-enable MU Control.
[*]When a locomotive is replaced, the train is changed to manual mode.  Since you cannot automatically couple two locomotives without them running into each other, creation of an MU consist is expected to be a manual process, but after upgrading a save file you will have to set trains back to automatic.
[*]Train kill statistics may not be preserved when upgrading/downgrading locomotives.
[/list]

Credits:
Noxy - Multidirectional Trains, which gave me the idea and some examples of train manipulation.
Optera - Train & Fuel Overhaul, which taught me how to make altered entities, and for releasing their copyPrototype library function to public domain.
