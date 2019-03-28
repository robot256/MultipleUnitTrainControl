# MultipleUnitTrainControl
Factorio mod written in Lua.  Lets locomotives provide backwards force in automatic if they are in a bidirectional pair.


- Type: Mod
- Name: Multiple Unit Train Control
- Description: Lets locomotives provide backwards force in automatic if they are in a bidirectional pair.
- License: MIT
- Source: GitHub
- Download: mods.factorio.com
- Version: 0.1.4
- Release: 2019-03-27
- Tested-With-Factorio-Version: 0.17.17
- Category: Helper, Train
- Tags: Train

Have you ever wished that all your locomotives would provide acceleration when running automatically, not just the ones facing forwards?  You're not alone!  With the power of Multiple Unit Train Control (MU Control) technology, a coupled pair of locomotives (an MU consist) can drive in either direction using the power of both!

## Summary
Simply take two locomotives of the same type and couple them together facing opposite directions.  Now you have an MU consist of two locomotives that can drive in either direction with the force of two locomotives.  It will also consume fuel at the rate of two locomotives.  Research Wireless MU Control and you can put wagons in between the two locomotives and still get the power boost.

This mod is meant to be an alternative to [Noxy's Multidirectional Trains](url=https://mods.factorio.com/mod/Noxys_Multidirectional_Trains).  I created it specifically to work with the [Automatic Coupling System](https://mods.factorio.com/mod/Automatic_Coupling_System) mod, because constantly uncoupling, reversing, and recoupling the trains interferes with the train alignment required to do realistic yard switching.  MU Control only modifies the train when the locomotives are first linked, so it doesn't change anything while coupling and uncoupling wagons automatically.

## Details
Under the hood, MU Control detects when a train is created with opposite-facing locomotives of the same type, and silently replaces them with a different entity, the "MU version", that have twice as much power as before.  As long as those two locomotives do not separate, MU Control never changes the train again.  If an MU locomotive is found to be without its twin, MU Control will immediately replace it with the normal version.

Since the game still thinks only one locomotive is driving, but with twice the power, the front locomotive will use twice as much fuel and the back won't use any.  MU Control automatically balances fuel between them periodically, so the single-direction range of the two together is the same as if they were both facing forward.  You can set the frequency of balancing or disable it in the mod settings.  If you let it drain to empty, it won't balance the last unit of fuel.

Four modes can be selected in the mod settings:
- Basic mode: Locomotives that are adjacent or separated by other locomotives can form MU consists.  Examples:  <L-L>, <L-<L-L>-L>
- Advanced (Wireless) mode: Locomotives can form MU consists anywhere in the train.  Examples:  <L-W-W-W-W-L>, <L-<L-W-W-L>-W-W-L>
- Tech Unlock mode: MU upgrades remain disabled until you complete research MU Control technology.  Unlock Wireless mode with a second research technology.  Note: After researching a new level, you must manually trigger an MU Control update on each existing train by coupling and uncoupling a wagon. This is to prevent instant upgrades from destroying trains if they are currently moving over a junction.
- Disabled mode: Reverts all MU locomotives to normal.  Note: Mod defaults to Disabled so that you have time to stop all your trains before enabling it.

## Features
- Upgrading and downgrading locomotives preserves color, name, health, fuel inventory, burner heat, and train schedule.
- Detects when the player uncouples locomotives of an MU consist.
- Mining, blueprinting, or pressing 'Q' over an MU version will produce its standard version.
- Mod setting to configure frequency for fuel balancing.
- Currently supports: Vanilla, [Train & Fuel Overhaul](https://mods.factorio.com/mods/Optera/TrainOverhaul)

## Planned Features
- Preserve contents of locomotive equipment grids on replacement.
- Support additional modded locomotives, especially [Realistic Electric Trains](https://mods.factorio.com/mod/Realistic_Electric_Trains).  If you want more, please send me suggestions!

## Known Issues
- When installing, enabling, or disabling the mod on an existing map, trains that are moving across an intersection during the upgrade may be disconnected, damaged or destroyed in the process.
- The MU version of each locomotive type is not craftable and should never end up in your inventory, but sometimes it does. It will revert as soon as you place it on a track.
- When a locomotive is replaced, the train is changed to manual mode.  Since you cannot automatically couple two locomotives without them running into each other, creation of an MU consist is expected to be a manual process, but after upgrading a save file you will have to set trains back to automatic.
- Train kill statistics may not be preserved when upgrading/downgrading locomotives.
- Mode is currently a runtime setting, so MU Control technologies will be available to research even if you have set MU Control to ignore them.

## Credits:
- Noxy - Multidirectional Trains, which gave me the idea and some examples of train manipulation.
- Optera - Train & Fuel Overhaul, which taught me how to make altered entities, and for releasing their copyPrototype library function to public domain.
- Train30 - Created the icon graphics for MU Control technologies.
- kryshnar - Provided French locale.