--Makes a sprite atlas for cards.
SMODS.Atlas{
	key = "FinalBosses",
	path = "FinalBosses.png",
	px = 71,
	py = 95
}
--Sprite atlas for missing/no textures.
SMODS.Atlas{
	key = "fb_NoTextures",
	path = "NoTextures.png",
	px = 71,
	py = 95
}

--Sprite atlas for Inazuma. Split off for easy removal if I end up splitting into 2+ mods.
SMODS.Atlas{
	key = "Inazuma",
	path = "Inazuma.png",
	px = 71,
	py = 95
}

--Sprite atlases for the Maverick suit.
SMODS.Atlas{
	key = "suitMaverickLC",
	path = "MaverickSuit.png",
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = "symbolMaverick",
	path = "MaverickSymbol.png",
	px = 18,
	py = 18
}

--Localization colours. Figured out thanks to Pokermon!
local fbcolors = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    fbcolors()
  end
  G.ARGS.LOC_COLOURS["inazuma"] = HEX("3EFFCC")
  G.ARGS.LOC_COLOURS["maverick"] = HEX("21E92A")
  return fbcolors(_c, _default)
end

--Custom Rarity for Dr. Inazuma
SMODS.Rarity{
	key = "inazuma",
	loc_txt = {
		name = 'Secret Boss'
	},
	badge_colour = HEX('426767'),
	pools = {},
	get_weight = function(self, weight, object_type)
        return weight
    end
}

--Custom Rarity for UNIMPLEMENTED jokers. This is so the mod won't spawn jank jokers while in dev!!
SMODS.Rarity{
	key = "unimplemented",
	loc_txt = {
		name = 'Unimplemented'
	},
	badge_colour = HEX('222222'),
	pools = {},
}

--Zero from Zero Escape. Oh god why did I pick them as my first one.
--Might be a bit too powerful for legendary since it's possible to get consistent X9, but it requires either building around 9s, or calculating digital roots on the fly. I think it's fine, but limiting it to 3+ card hands would make it more flavourful as well as making it more of a "build around", like Triboulet.
--Design by Kotetsu
SMODS.Joker{
	key = 'zero999',
	config = { extra = { Xmult = 1, totalHand = 0 } },
	rarity = 4,
	atlas = 'FinalBosses',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 25,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { --Thanks to john smods for helping me figure out this!
			set = "Other",
			key = "DigitalRoot"
		}
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		--Thanks to the mod More Fluff for helping me figure out full_hand!
		if context.before 
			and not context.blueprint
			and not context.repetition
			and context.full_hand
		then
			for i,v in ipairs(context.full_hand) do
				if not SMODS.has_no_rank(v) then --Thanks for the help, SDM_0 and srockw!
					if v:get_id() == 14 then
						card.ability.extra.totalHand = card.ability.extra.totalHand + 1
					elseif v:get_id() <= 10 then
						card.ability.extra.totalHand = card.ability.extra.totalHand + v:get_id()
					end
				end
			end
		end
		if context.joker_main and not context.blueprint and not context.repetition then
			card.ability.extra.Xmult = math.fmod(card.ability.extra.totalHand, 9)
			if card.ability.extra.totalHand == 0 then
				card.ability.extra.Xmult = 1
			elseif card.ability.extra.Xmult == 0 then
				card.ability.extra.Xmult = 9
			end
			return{
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
		if context.after then
			card.ability.extra.totalHand = 0
		end
	end
}

--Dacuya SOTN. Throws his funny glass.
--I'm Dracula! I'm 12 million years old!
--Design by Kotetsu + Arti
SMODS.Joker{
	key = 'dracula',
	rarity = 4, --I was flipping bricks for Mansa Musa before yall were a Type 1 Civilization!
	atlas = 'FinalBosses',
	pos = { x = 4, y = 0 },
	soul_pos = { x = 4, y = 1 },
	cost = 25, --It doesn't matter if I go blind, I don't need to see the price tag, anyway!
	config = { extra = { Xmult = 1, Xmult_mod = 1 } },
	pools = {["Meme"] = true},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod } }
	end,
	calculate = function(self, card, context)
		if
			context.discard
			and #context.full_hand == 1
			and not context.other_card.debuff --This shit ain't nothin' to me, man!
			and SMODS.has_enhancement(context.other_card, 'm_glass')
			and not context.blueprint			
		then --I can't wait to curbstomp you in these dumb ugly ass Rick Owen shoes
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card,
				remove = true --Faded out to black, and I let the archangels take him.
			}
		end	
		if context.joker_main then	
			return{
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult --Rome wasn't built in a day, but this 9mm sure was!
			}
		end
	end
}

--Chaos from Aria of Sorrow.
--Deliberately synergizes with Dracula, but is also more than playable without.
--Design by Arti
SMODS.Joker{
	key = 'chaos_aos',
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
	end,
	calculate = function(self, card, context)
		if
			context.individual and
			context.cardarea == G.play and
			SMODS.has_enhancement(context.other_card, 'c_base')
		then
			context.other_card:set_ability(G.P_CENTERS.m_glass,nil,true)
		end
	end,
	rarity = 4,
	atlas = 'FinalBosses',
	pos = { x = 5, y = 0 },
	soul_pos = { x = 5, y = 1 },
	cost = 25
}

--Okina Matara from HSIFS.
--Sure, it's her two dancers that actually caused the back doors that empowered the youkai of gensokyo - but she's responsible, so it's her joker.
--Design by Kotetsu
SMODS.Joker{
	key = 'okinamatara',
	rarity = 4,
	atlas = 'FinalBosses',
	pos = { x = 7, y = 0 },
	soul_pos = { x = 7, y = 1 },
	backsprite = { x = 7, y = 2 },
	cost = 25,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if
			context.retrigger_joker_check and
			not context.retrigger_joker and
			context.other_card.config.center.rarity == 1
		then
			G.E_MANAGER:add_event(Event({
				func = function()
				context.other_card:juice_up(0.5, 0.5)
				return true
				end
			}))
			return {
					message = localize("k_again_ex"),
					repetitions = 4,
					card = card,
			}
		end
	end,
}

-- #   # ##### ####   ####
-- # # #   #   #   # #
-- # # #   #   ####   ###
-- # # #   #   #         #
--  # #  ##### #     ####

-- Half-finished ideas beyond this zone!! watch out.

--Ultimecia, from FF8. Compresses all hands into 1. Gives a bonus based on max hands?
--Design by Kotetsu + Arti.
SMODS.Joker{
	key = 'ultimecia',
	loc_txt = {
		name = 'Ultimecia',
		text = {
			"{X:negative,C:red}Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"All hands and discards are considered the",
			"{C:attention}first and last hand{} and {C:attention}discard{} of the round",
			" ",
			"{X:mult,C:white}XMult{} equal to your Hands, then",
			"{C:attention}lose all Hands",
			" ",
			"{C:inactive}''Past... Present... Future... Infinite possibilities... Condensed into a single moment!''{}",
			"{C:inactive,s:0.8}Source: Final Fantasy VIII{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"		
			--This is TOTALLY cheating, since it's actually from FFXIV E12S phase 2. ... but it works so well for her.
			--If I forced myself to use an actual quote from her, I'd use this:
			--''I am Ultimecia. Time shall compress... All existence denied.''
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 1, y = 0 },
	soul_pos = { x = 1, y = 1 },
	cost = 25,
	no_doe = true
}

--Beatrice, from Umineko. Peak fiction. ahaha.wav. Probably does something with gold cards and/or money.
--TODO: Work out what Beato does.
SMODS.Joker{
	key = 'beatrice',
	loc_txt = {
		name = '{C:money}Beatrice, the Golden Witch{}',
		text = {
			"{X:negative,C:red}Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"Without love, it cannot be 'seen.'",
			" ",
			"{C:inactive}''And let me also say this. {C:mult}You are incompetent{C:inactive}!'' *cackle*cackle*{}",
			"{C:inactive,s:0.8}Source: Umineko: When They Cry{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 2, y = 0 },
	soul_pos = { x = 2, y = 1 },
	cost = 25,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
	end
}

--Dr. Albert Wily, from Megaman. Something to do with 3 of a kind, to fit with Wily Joker. Maybe steel cards are involved?
--TODO: Work out what Wily does.
SMODS.Joker{
	key = 'dr_albertwily',
	loc_txt = {
		name = 'Dr. Albert Wily',
		text = {
			"{X:negative,C:red}Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"If played hand is a",
			"{C:attention}Three of a Kind{},",
			"Effect of some sort goes here",
			" ",
			"{C:inactive}''Hahahahaha! Just try and stop me, if you think you can!''{}",
			"{C:inactive,s:0.8}Source: Mega Man (Classic){}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 3, y = 0 },
	soul_pos = { x = 3, y = 1 },
	cost = 25,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
	end
}

--Koishi Komeiji.
--Okay I'm pretty sure I'll never be able to figure out how to code this one but the idea is so cool I have to at least attempt it.
--She's not really an antagonist but "I love not thinking!"
--Design by Arti
SMODS.Joker{
	key = 'koishikomeiji',
	loc_txt = {
		name = 'Koishi Komeiji',
		text = {
			"{X:negative,C:red}Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"Copies ability of a {C:attention}random {C:legendary,E:1}Legendary{} Joker",
			"from {C:attention}all possible{} {C:legendary,E:1}Legendary {}Jokers.",
			"Changes when {C:attention}Blind{} is selected",
			"{C:inactive,s:0.8}(You do not get to know which joker.)",
			" ",
			"{C:inactive}''I love not thinking!''{}",
			"{C:inactive,s:0.8}Source: Touhou 11: Subterranean Animism{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
		--TODO: Something with glitchy misprint text?
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 6, y = 0 },
	soul_pos = { x = 6, y = 1 },
	cost = 25
}

--Nyx Avatar from Persona 3.
--Design by Arti
SMODS.Joker{
	key = 'nyxavatar',
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 8, y = 0 },
	soul_pos = { x = 8, y = 1 },
	cost = 25,
	calculate = function(self, card, context)
		if context.discard then 
		end	
	end
}

--Lavos from Chrono Trigger.
--Design by Arti
SMODS.Joker{
	key = 'Lavos',
	loc_txt = {
		name = 'Lavos',
		text = {
			"{X:negative,C:red}Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"If played hand is an {C:attention}Ace{} and three {C:attention}9s{},",
			"--Unknown Effect--",
			" ",
			"{C:inactive}''Unimaginable is the power of Lavos. Anyone who dares to oppose it... meets certain doom.'' - Magus{}",
			"{C:inactive,s:0.8}Source: Chrono Trigger{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'FinalBosses',
	pos = { x = 9, y = 0 },
	soul_pos = { x = 9, y = 1 },
	cost = 25
}

--Nicol Bolas from Magic: The Gathering.
--Maybe selling a joker gives a bonus based on rarity.
--[[
Common: +Chips
Uncommon: xChips
Rare: +Mult
Epic: +Mult (doubled?)
Legendary: XMult
Exotic and higher: ^Mult
--Thanks to DragoKillFist for the idea!
SMODS.Joker{
	key = 'nicolbolas',
	loc_txt = {
		name = 'Nicol Bolas',
		text = {
			"{X:negative,C:red}WIP / Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"{C:attention}Destroys{} another random {C:legendary,E1}Legendary{} Joker",
			"whenever you select a Blind, then gains {X:mult,C:white}X2{} Mult",
			"{C:inactive}(Currently {X:mult,C:white}X1{C:inactive} Mult)",
			" ",
			"{C:inactive}''There is no greater folly than standing against me.''{}",
			"{C:inactive,s:0.8}Source: Magic: The Gathering{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'fb_NoTextures',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 25
}
--]]

--Sigma from Mega Man X.
--[[
SMODS.Joker{
	key = 'sigma',
	loc_txt = {
		name = 'Sigma',
		text = {
			"{X:negative,C:red}WIP / Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"Transforms a random non-{C:maverick}Maverick{} card in",
			"played hands into the {C:maverick}Maverick{} suit",
			"{C:maverick}Maverick{} cards give {X:mult,C:white}X2{} Mult",
			" ",
			"{C:inactive}''Example quote!''{}",
			"{C:inactive,s:0.8}Source: Mega Man X{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'fb_NoTextures',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 25
}
--]]

--The Maverick suit, used by Sigma.
--[[
SMODS.Suit{
	key = 'maverick',
	card_key = 'M',
	pos = {y = 0},
	ui_pos = {x = 0, y = 0},
	lc_ui_atlas = 'symbolMaverick',
	lc_atlas = 'suitMaverickLC',
	lc_color = HEX('21E92A')
}
--]]

--Template jonker.
--[[
SMODS.Joker{
	key = 'indev_template',
	loc_txt = {
		name = 'Template Joker',
		text = {
			"{X:negative,C:red}WIP / Unimplemented{}",
			"{C:attention}Effects are not final.{}",
			" ",
			"This is a template joker so I can easily make new ones.",
			" ",
			"{C:inactive}''Example quote!''{}",
			"{C:inactive,s:0.8}Source: Lua{}",
			"{C:inactive,s:0.6}Currently using dev graphics...{}"
		}
	},
	rarity = 'finalboss_unimplemented',
	atlas = 'fb_NoTextures',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 25
}
]]--

--Dr. Kaizo Inazuma, shameless self insert. I have no idea what he'll do. Just a teaser for now!
--TODO: Work out what Inazuma does. Probably Exotic power level? 
SMODS.Joker{
	key = 'dr_kaizoinazuma',
	loc_txt = {
		name = '{C:inazuma}Dr. Kaizo Inazuma{}',
		text = {
			"{C:inactive,E:2}''Now now, let's not get too hasty.~{}",
			"{C:inactive,E:2}I'll be ready to join the fun when the time is right.{}",
			"{C:inactive,E:2}But for now? I think I'll just watch.~''{}"
		}
	},
	rarity = 'finalboss_inazuma',
	atlas = 'Inazuma',
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 50,
	unlocked = true,
	discovered = true
}