# TeronAPI
A set of custom API functions created for different classes in Vanilla World of Warcraft (and Turtle WoW), to help reduce the size of macro scripts.
To use the following custom APIs, all your have to do, is to put "/run *name of the API without spaces*()" in an in-game macro and you're all set!

List of available functions:

  **Warrior custom APIs:**
  1. **WarriorRangePull()** -> depending on the type of weapon equiped, shoots with the respective ability *(shoot bow, shoot gun, shoot crossbow, throw)*; decreases time to swap abilities on the action bar
  2. **WarriorChargeInterceptCast()** -> allows for the usage of both Charge and Intercept with the click of only one button; Charge out of combat and Intercept in combat, respectively
  3. **WarriorInterveneCast()** -> the function works similarly to how the macro for Blessing of Protection (Hand of Protection) works; checks if the target of your target (usually a party or raid member) is alive, a friendly target and if they are in your party, if so, then casts Intervene on the target
  4. **WarriorLimitedHeroicStrikeCast()** -> limits the usage of *(turns off)* Heroic Strike when the user has less than a specific amount of rage *(can be adjusted to your needs in the .lua file)*
  5. **WarriorBerserkerRageCast()** -> casts Berserker Rage, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  6. **WarriorDisarmCast()** -> casts Disarm, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  7. **WarriorMockingBlowCast()** -> casts Mocking Blow, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  8. **WarriorTauntCast()** -> casts Taunt, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  9. **WarriorThunderClapCast()** -> casts Thunder Clap, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  10. **WarriorSunderArmorCast()** -> casts Sunder Armor, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  11. **WarriorFiveSunderRule()** -> allows for the use of Sunder Armor if there's not 5 sunders already on the target, additionally puts you in the correct stance for Sunder Armor *(Defensive Stance)*
  12. **WarriorRendCast()** -> casts Rend, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
