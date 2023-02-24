-- We want to different versions of texts that support different locales.
BitesCookBook.Locales = {}

-- Supported locales are:
-- English (enUS)
-- French (frFR)
-- German (deDE)
-- Spanish (esES)

-- The default locale is English.
BitesCookBook.Locales["enUS"] = {}
BitesCookBook.Locales["enUS"]["UsedHint"] = "Used in cooking."
BitesCookBook.Locales["enUS"]["IngredientFor:"] = "Ingredient for:"
BitesCookBook.Locales["enUS"]["Starter"] = "Starter"
BitesCookBook.Locales["enUS"]["Recipe:"] = "Recipe:"

-- The following are the options for the addon.
BitesCookBook.Locales["enUS"]["OptIngTitle"] = "Ingredient Tooltips"
BitesCookBook.Locales["enUS"]["OptIngDesc"] = "These are Options that modify which recipe-information is shown on the tooltip of ingredients."
BitesCookBook.Locales["enUS"]["ShowIngredientTooltip"] = "Show ingredient tooltips."
BitesCookBook.Locales["enUS"]["HideReagentTooltipsButHint"] = "Only show if an item is used for cooking."
BitesCookBook.Locales["enUS"]["ShowCraftableFirstRank"] = "Show at what skill level a meal becomes available."
BitesCookBook.Locales["enUS"]["ShowCraftableRankRange"] = "Also show at what subsequent skill-levels the meal's efficiency changes."
BitesCookBook.Locales["enUS"]["GrayHighCraftables"] = "Gray out recipes that are not yet available to your rank."
BitesCookBook.Locales["enUS"]["ColorCraftableByRank"] = "Color a meal according to your rank."
BitesCookBook.Locales["enUS"]["ShowCraftableIcon"] = "Show a picture of the meal."
BitesCookBook.Locales["enUS"]["RankThreshold"] = "Rank threshold "

BitesCookBook.Locales["enUS"]["Misc"] = "Miscellaneous"
BitesCookBook.Locales["enUS"]["ShowCraftableTooltip"] = "Show meal/recipe tooltips."
BitesCookBook.Locales["enUS"]["ShowEnemyTooltip"] = "Show possible ingredients under enemies."
BitesCookBook.Locales["enUS"]["ColorDropsByRank"] = "Color an ingredient based on the highest ranking meal it can be used for."
BitesCookBook.Locales["enUS"]["WhenModifierPressed"] = "When modifier is pressed:"
BitesCookBook.Locales["enUS"]["DoNothing"] = "Do nothing"
BitesCookBook.Locales["enUS"]["ShowTooltip"] = "Show tooltip"
BitesCookBook.Locales["enUS"]["HideTooltip"] = "Hide tooltip"
BitesCookBook.Locales["enUS"]["RevealKey"] = "Reveal Tooltip Key"
BitesCookBook.Locales["enUS"]["Key"] = " Key"

-- For French, we repeat the English text afterwards as a comment. The comments should be aligned in script.
-- For example:
BitesCookBook.Locales["frFR"] = {}
BitesCookBook.Locales["frFR"]["UsedHint"] = "Utilisé en cuisine."           -- Used in cooking.
BitesCookBook.Locales["frFR"]["IngredientFor:"] = "Ingrédient pour:"        -- Ingredient for:
BitesCookBook.Locales["frFR"]["Starter"] = "Entrée"                         -- Starter
BitesCookBook.Locales["frFR"]["Recipe:"] = "Recette:"                       -- Recipe:

BitesCookBook.Locales["frFR"]["OptIngTitle"] = "Info-bulles d'ingrédients"  -- Ingredient Tooltips
BitesCookBook.Locales["frFR"]["OptIngDesc"] = "Ces options modifient les informations affichées sur les info-bulles des ingrédients." -- These are Options that modify which recipe-information is shown on the tooltip of ingredients.
BitesCookBook.Locales["frFR"]["ShowIngredientTooltip"] = "Afficher les info-bulles des ingrédients." -- Show ingredient tooltips.
BitesCookBook.Locales["frFR"]["HideReagentTooltipsButHint"] = "Afficher seulement si un objet est utilisé en cuisine." -- Only show if an item is used for cooking.
BitesCookBook.Locales["frFR"]["ShowCraftableFirstRank"] = "Afficher à quel niveau de compétence une recette est disponible." -- Show at what skill level a meal becomes available.
BitesCookBook.Locales["frFR"]["ShowCraftableRankRange"] = "Afficher également à quel niveau de compétence la recette devient plus efficace." -- Also show at what subsequent skill-levels the meal's efficiency changes.
BitesCookBook.Locales["frFR"]["GrayHighCraftables"] = "Griser les recettes qui ne sont pas encore disponibles pour votre niveau de compétence." -- Gray out recipes that are not yet available to your rank.
BitesCookBook.Locales["frFR"]["ColorCraftableByRank"] = "Colorer une recette selon votre niveau de compétence." -- Color a meal according to your rank.
BitesCookBook.Locales["frFR"]["ShowCraftableIcon"] = "Afficher une image de la recette." -- Show a picture of the meal.
BitesCookBook.Locales["frFR"]["RankThreshold"] = "Seuil de niveau de compétence " -- Rank threshold

BitesCookBook.Locales["frFR"]["Misc"] = "Divers"                             -- Miscellaneous
BitesCookBook.Locales["frFR"]["ShowCraftableTooltip"] = "Afficher les info-bulles des recettes." -- Show meal/recipe tooltips.
BitesCookBook.Locales["frFR"]["ShowEnemyTooltip"] = "Afficher les ingrédients possibles sous les ennemis." -- Show possible ingredients under enemies.
BitesCookBook.Locales["frFR"]["ColorDropsByRank"] = "Colorer un ingrédient selon le niveau de compétence de la recette la plus élevée qui peut l'utiliser." -- Color an ingredient based on the highest ranking meal it can be used for.
BitesCookBook.Locales["frFR"]["WhenModifierPressed"] = "Quand la touche de modification est pressée:" -- When modifier is pressed:
BitesCookBook.Locales["frFR"]["DoNothing"] = "Ne rien faire"                -- Do nothing
BitesCookBook.Locales["frFR"]["ShowTooltip"] = "Afficher l'info-bulle"      -- Show tooltip
BitesCookBook.Locales["frFR"]["HideTooltip"] = "Cacher l'info-bulle"        -- Hide tooltip
BitesCookBook.Locales["frFR"]["RevealKey"] = "Touche pour afficher l'info-bulle" -- Reveal Tooltip Key
BitesCookBook.Locales["frFR"]["Key"] = " Touche"                            -- Key


-- For German, we repeat the English text afterwards as a comment. The comments should be aligned in script.
-- For example:
BitesCookBook.Locales["deDE"] = {}
BitesCookBook.Locales["deDE"]["UsedHint"] = "Wird in der Küche verwendet."  -- Used in cooking.
BitesCookBook.Locales["deDE"]["IngredientFor:"] = "Zutat für:"              -- Ingredient for:
BitesCookBook.Locales["deDE"]["Starter"] = "Vorspeise"                      -- Starter
BitesCookBook.Locales["deDE"]["Recipe:"] = "Rezept:"                        -- Recipe:

BitesCookBook.Locales["deDE"]["OptIngTitle"] = "Zutaten-Tooltip"            -- Ingredient Tooltips
BitesCookBook.Locales["deDE"]["OptIngDesc"] = "Diese Optionen ändern die Informationen, die im Tooltip von Zutaten angezeigt werden." -- These are Options that modify which recipe-information is shown on the tooltip of ingredients.
BitesCookBook.Locales["deDE"]["ShowIngredientTooltip"] = "Zutaten-Tooltip anzeigen." -- Show ingredient tooltips.
BitesCookBook.Locales["deDE"]["HideReagentTooltipsButHint"] = "Nur anzeigen, wenn ein Gegenstand in der Küche verwendet wird." -- Only show if an item is used for cooking.
BitesCookBook.Locales["deDE"]["ShowCraftableFirstRank"] = "Zeige ab welchem Kochlevel ein Rezept verfügbar ist." -- Show at what skill level a meal becomes available.
BitesCookBook.Locales["deDE"]["ShowCraftableRankRange"] = "Zeige auch ab welchem Kochlevel das Rezept effektiver wird." -- Also show at what subsequent skill-levels the meal's efficiency changes.
BitesCookBook.Locales["deDE"]["GrayHighCraftables"] = "Graue Rezepte, die noch nicht für dein Kochlevel verfügbar sind." -- Gray out recipes that are not yet available to your rank.
BitesCookBook.Locales["deDE"]["ColorCraftableByRank"] = "Färbe Rezepte nach deinem Kochlevel." -- Color a meal according to your rank.
BitesCookBook.Locales["deDE"]["ShowCraftableIcon"] = "Zeige ein Bild des Rezepts." -- Show a picture of the meal.
BitesCookBook.Locales["deDE"]["RankThreshold"] = "Kochlevel-Schwelle"        -- Rank threshold

BitesCookBook.Locales["deDE"]["Misc"] = "Verschiedenes"                     -- Miscellaneous
BitesCookBook.Locales["deDE"]["ShowCraftableTooltip"] = "Zeige Rezept-Tooltip." -- Show meal/recipe tooltips.
BitesCookBook.Locales["deDE"]["ShowEnemyTooltip"] = "Zeige mögliche Zutaten unter Gegnern." -- Show possible ingredients under enemies.
BitesCookBook.Locales["deDE"]["ColorDropsByRank"] = "Färbe Zutaten nach dem Kochlevel des effektivsten Rezepts, das sie verwenden kann." -- Color an ingredient based on the highest ranking meal it can be used for.
BitesCookBook.Locales["deDE"]["WhenModifierPressed"] = "Wenn die Modifikationstaste gedrückt wird:" -- When modifier is pressed:
BitesCookBook.Locales["deDE"]["DoNothing"] = "Nichts tun"                   -- Do nothing
BitesCookBook.Locales["deDE"]["ShowTooltip"] = "Tooltip anzeigen"          -- Show tooltip
BitesCookBook.Locales["deDE"]["HideTooltip"] = "Tooltip verstecken"        -- Hide tooltip
BitesCookBook.Locales["deDE"]["RevealKey"] = "Taste zum Anzeigen des Tooltips" -- Reveal Tooltip Key
BitesCookBook.Locales["deDE"]["Key"] = " Taste"                             -- Key


-- For Spanish, we repeat the English text afterwards as a comment. The comments should be aligned in script.
-- For example:
BitesCookBook.Locales["esES"] = {}
BitesCookBook.Locales["esES"]["UsedHint"] = "Usado en la cocina."           -- Used in cooking.
BitesCookBook.Locales["esES"]["IngredientFor:"] = "Ingrediente para:"       -- Ingredient for:
BitesCookBook.Locales["esES"]["Starter"] = "Entrante"                       -- Starter
BitesCookBook.Locales["esES"]["Recipe:"] = "Receta:"                        -- Recipe:

BitesCookBook.Locales["esES"]["OptIngTitle"] = "Información de ingredientes" -- Ingredient Tooltips
BitesCookBook.Locales["esES"]["OptIngDesc"] = "Estas opciones modifican la información que se muestra en la información sobre herramientas de los ingredientes." -- These are Options that modify which recipe-information is shown on the tooltip of ingredients.
BitesCookBook.Locales["esES"]["ShowIngredientTooltip"] = "Mostrar información de ingredientes." -- Show ingredient tooltips.
BitesCookBook.Locales["esES"]["HideReagentTooltipsButHint"] = "Mostrar sólo si un objeto se usa en la cocina." -- Only show if an item is used for cooking.
BitesCookBook.Locales["esES"]["ShowCraftableFirstRank"] = "Mostrar el nivel de cocina necesario para la receta." -- Show at what skill level a meal becomes available.
BitesCookBook.Locales["esES"]["ShowCraftableRankRange"] = "Mostrar el nivel de cocina necesario para que la receta sea más eficiente." -- Also show at what subsequent skill-levels the meal's efficiency changes.
BitesCookBook.Locales["esES"]["GrayHighCraftables"] = "Grisar las recetas que no están disponibles para tu nivel de cocina." -- Gray out recipes that are not yet available to your rank.
BitesCookBook.Locales["esES"]["ColorCraftableByRank"] = "Colorear las recetas según tu nivel de cocina." -- Color a meal according to your rank.
BitesCookBook.Locales["esES"]["ShowCraftableIcon"] = "Mostrar una imagen de la receta." -- Show a picture of the meal.
BitesCookBook.Locales["esES"]["RankThreshold"] = "Umbral de nivel de cocina" -- Rank threshold

BitesCookBook.Locales["esES"]["Misc"] = "Miscelánea"                       -- Miscellaneous
BitesCookBook.Locales["esES"]["ShowCraftableTooltip"] = "Mostrar información de recetas." -- Show meal/recipe tooltips.
BitesCookBook.Locales["esES"]["ShowEnemyTooltip"] = "Mostrar ingredientes posibles bajo enemigos." -- Show possible ingredients under enemies.
BitesCookBook.Locales["esES"]["ColorDropsByRank"] = "Colorear ingredientes según el nivel de cocina de la receta más eficiente que pueden usar." -- Color an ingredient based on the highest ranking meal it can be used for.
BitesCookBook.Locales["esES"]["WhenModifierPressed"] = "Cuando se presiona la tecla modificadora:" -- When modifier is pressed:
BitesCookBook.Locales["esES"]["DoNothing"] = "No hacer nada"               -- Do nothing
BitesCookBook.Locales["esES"]["ShowTooltip"] = "Mostrar información"       -- Show tooltip
BitesCookBook.Locales["esES"]["HideTooltip"] = "Ocultar información"       -- Hide tooltip
BitesCookBook.Locales["esES"]["RevealKey"] = "Tecla para mostrar información" -- Reveal Tooltip Key
BitesCookBook.Locales["esES"]["Key"] = " Tecla"                             -- Key