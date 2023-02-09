import re

class Misc():
    """ A class to represent a type that we are not interested in."""
    def __init__(self):
        pass
    
    def __repr__(self):
        return "Not a recipe."

class Item():
    """ A class to represent an item in the game."""
    def __init__(self, id: int, name: str, dropped_by: dict) -> None:
        self.id = id
        self.name = name
        self.dropped_by = dropped_by
    
    def __repr__(self):
        return f"{self.name} (id: {self.id})"

class Recipe():
    """ A class to represent a recipe in the game."""
    
    def __init__(self, level_range, id, name, amount, spell_id, reagents, source) -> None:
        self.id = id
        self.name = name
        self.amount = amount
        
        self.level_range = level_range
        self.spell_id = spell_id
        self.reagents = reagents
        self.source = source
    
    @classmethod
    def read(cls, spell_from_regex: str) -> tuple:
        """ Reads the JavaScript string using regex and creates a Recipe object."""
    
        level_range = re.findall('colors":\[(.*?)\]', spell_from_regex)
        if level_range == []:
            return Misc()
        
        # The regex output is a list of a string, that looks like a list of integers.
        level_range = [int(x) for x in level_range[0].split(',')]
        
        meal_information = re.findall('creates":\[(.*?)\]', spell_from_regex)
        meal_information = [int(x) for x in meal_information[0].split(',')]
        
        id = int(meal_information[0])
        amount = meal_information[1]
        name = re.findall('name":"(.*?)",', spell_from_regex)[0]
        
        spell_id = int(re.findall('id":(.*?),', spell_from_regex)[0])
        
        # Create a list of lists, i.e. [ [reagent_id, reagent_amount], [reagent_id, reagent_amount], ... ]
        reagent_list = re.findall('reagents":\[(.*?)\],"', spell_from_regex)[0]
        reagents = [[int(x) for x in ingredient.split(",")] for ingredient in re.findall("\[(.*?)\]", reagent_list)]
        
        # Check if the recipe is a trainer recipe or if found in the world (i.e. vendor, drop, quest, etc.).
        if re.findall('source":\[(.*?)\],"', spell_from_regex) == []:
            source = "World"
        else:
            source = "Trainer"
        
        return cls(level_range, id, name, amount, spell_id, reagents, source)
    
    def __repr__(self):
        return f"Spell: {self.spell_id} | {self.amount} x {self.name} (id: {self.id}) <- {self.reagents}"
    
    def __call__(self):
        print(self.name, self.source)
    
    def get_LUA_list(self, name_to_id_list: dict):
        """ Returns a string that is used to create a LUA table for the addon to read from."""
        
        name_line = f'[{self.id}]'+' = { -- '+f'{self.name}'
        range_line = '["Range"] = ' +str(self.level_range).replace("[", "{").replace("]", "}")+ ','
        source_line = '["Source"] = {"'+self.source+'"},'
        amount_line = '["Amount"] = '+str(self.amount)+','
        materials_line = '["Materials"] = {'
        for (reagent_id, amount) in self.reagents:
            materials_line += f'\n\t\t\t[{reagent_id}] = {amount}, --{name_to_id_list[reagent_id]}'
        materials_line = materials_line + '\n\t\t},'
        end_line = "},"
        return "\t" +name_line +"\n\t\t" +amount_line + "\n\t\t" +range_line +"\n\t\t" +source_line +"\n\t\t" +materials_line +"\n\t" +end_line +"\n\n"