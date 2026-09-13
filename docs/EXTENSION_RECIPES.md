# Extension recipes

These are small decision guides for later milestones. Follow the relevant
milestone contract when it arrives; the recipes describe where the work belongs
without committing the project to a genre.

## Add a new permanent resource

When the progression framework exists:

1. Add the resource definition to the progression configuration.
2. Give it a stable identifier and display name.
3. Decide which run events earn it and which home actions spend it.
4. Add it to the home UI only after earning and spending both work.
5. Document the identifier and a balancing note in the feature README.

Avoid storing a resource only in a label. The service must own the value so a
save, a shop, and a reward summary agree.

## Add an upgrade

Define the cost, prerequisites, maximum level, and one explicit effect. The
effect should be a named value the run can read, such as starting_health,
pickup_radius, or enemy_reward_multiplier. Keep a first upgrade simple enough
to verify in a later run before combining effects.

## Add a run mechanic

Put the mechanic in game/ if it defines the participant's genre. Extract a
component only after a second scene needs the same behavior. At run completion,
return all permanent rewards through the shared result contract instead of
writing save data from a random gameplay node.

## Add an interface panel

Start with the shared theme. Make the panel consume a feature's public state
and emit an intention, such as purchase_requested. Let the feature decide
whether the request succeeds, then refresh the panel from the resulting state.

## Replace the supplied demo

Keep app/, features/, ui/, and game/ intact. Remove demo/ only after the
replacement home and run scenes satisfy the documented RunContext and RunResult
contract. Run the project immediately after removal; no demo script should be
an implicit dependency.
