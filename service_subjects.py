service_choices = []
items = """Field training/field craft
Drill 
Weapon training
Physical training
Map Reading
Military law
Signals
Field engineering
First aid
General service knowledge
Intelligence and security
Driving and maintenence
Equitation
Military history
Internal security
Geopolitics
Essentials of leadership
Organisation and administration
Method of instructions
Service writing
French
Ex Camp initial
Ex Camp brush-up
Ex Camp okwu
Ex Camp farauta
Ex Camp kurata
Ex Camp kura
Ex pre-camp highland
Ex Camp Highland
General navigation
Seamanship
Divisional duties
Communications
Rules of the road
Under water warfare
Nuclear, biological, chemical warfare and damage control
Accounts and budget
Logistics
Above water warfare
Service writing (navy)
Naval law
Provost and regulating duties
Action information organisation
Marine engineering
Weapon electrical engineering
Military history (Naval campaigns)
Current affairs
Computer application
Nigerian constitution
Attachment to onne 
Ex Camp ruwan yaro
Ex Camp baban yaro
Midshipman training
Tours
Aerodynamics
Air navigation
Air traffic control
Meteorology 
Air Power
Air force law
Service writing(airforce)
Air craft general
Admin instruction
Officership, leadership and command
Ex Camp asha enu-igwe
Ex Camp belemu
Ex Camp bette
Ex Camp mazan fama"""

split_item = items.splitlines()

for item in split_item:
    tuple_item = (item, item.title())
    service_choices.append(tuple_item)
