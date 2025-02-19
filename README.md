# TeronAPI
A set of custom API functions created for different classes in Vanilla World of Warcraft (and Turtle WoW), to help reduce the size of macro scripts.
To use the following custom APIs, all your have to do, is to put "/run *name of the API without spaces*()" in an in-game macro and you're all set!

List of available functions:

  **General custom APIs:**
  1. **StartAutoAttack()** -> a pretty reliable auto-attack API, which uses a double checking method to ensure that you will always get to attack your target without the need for extra addons

  **Warrior custom APIs:**
  1. **WarriorRangePull()** -> depending on the type of weapon equiped, shoots with the respective ability *(shoot bow, shoot gun, shoot crossbow, throw)*; decreases time to swap abilities on the action bar
  2. **WarriorChargeInterceptCast()** -> allows for the usage of both Charge and Intercept with the click of only one button; Charge out of combat and Intercept in combat, respectively
  3. **WarriorLimitedHeroicStrikeCast()** -> limits the usage of *(turns off)* Heroic Strike when the user has less than a specific amount of rage *(can be adjusted to your needs in the .lua file)*
  4. **WarriorBerserkerRageCast()** -> casts Berserker Rage, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  5. **WarriorDisarmCast()** -> casts Disarm, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  6. **WarriorMockingBlowCast()** -> casts Mocking Blow, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  7. **WarriorTauntCast()** -> casts Taunt, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  8. **WarriorThunderClapCast()** -> casts Thunder Clap, but first makes sure your're in the correct stance *(does the stance dancing without too much script in your macro)*
  9. **WarriorFiveSunderRule()** -> allows for the use of Sunder Armor if there's not 5 sunders already on the target, additionally puts you in the correct stance for Sunder Armor *(Defensive Stance)*
