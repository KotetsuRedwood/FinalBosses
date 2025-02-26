return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={},
        Joker={
			j_finalboss_zero999 = {
					name = 'Zero',
					text = {
						"{X:mult,C:white}XMult{} equal to the",
						"{C:attention}digital root{} of",
						"numbered cards in played hand",
						"{C:inactive}(Minimum {X:mult,C:white}X1{C:inactive}){}",
						" ",
						"{C:inactive}''Seek a way out... Seek a door that carries a [9].''{}",
						"{C:inactive,s:0.8}Source: Zero Escape: 9 Hours, 9 Persons, 9 Doors{}",
						"{C:inactive,s:0.6}Currently using dev graphics...{}"
					}
				},
			j_finalboss_dracula = {
					name = 'Dracula',
					text = {
						"If {C:attention}discarded hand{} is a single",
						"{C:attention}Glass Card{}, destroy it",
						"and this Joker gains {X:mult,C:white}X#2#{} Mult",
						"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
						" ",
						"{C:inactive}''What is a man? A miserable little pile of secrets!''{}",
						"{C:inactive,s:0.8}Source: Castlevania: Symphony of the Night{}",
						"{C:inactive,s:0.6}Currently using dev graphics...{}"
					}
				},
			j_finalboss_chaos_aos = {
					name = 'Chaos',
					text = {
						"Scored {C:attention}non-Enhanced{} cards",
						"become {C:attention}Glass Cards",
						" ",
						--"{C:inactive}''Example quote!''{}", (Supposedly it doesn't have quotes, but I should probably play Mario of Sorrow anyway)
						"{C:inactive,s:0.8}Source: Castlevania: Aria of Sorrow{}",
						"{C:inactive,s:0.6}Currently using dev graphics...{}"
					}
				},
			j_finalboss_okinamatara = {
					name = 'Okina Matara',
					text = {
						"All {C:blue}Common{} Jokers retrigger {C:attention}4{} times",
						" ",
						"{C:inactive}''For the true power of a hidden god, you had better savor every last drop!''{}",
						"{C:inactive,s:0.8}Source: Touhou 16: Hidden Star In Four Seasons{}",
						"{C:inactive,s:0.6}Currently using dev graphics...{}"
					}
				},
			j_finalboss_nyxavatar = {
					name = 'Nyx Avatar',
					text = {
						"{C:red}Work in Progress{}",
						"{C:attention}May not work as intended.{}",
						" ",
						"Generates a {C:tarot}Tarot{} card",
						"whenever you {C:attention}discard{}",
						" ",
						"{C:inactive}''The Arcana is the means by which all is revealed...''{}",
						"{C:inactive,s:0.8}Source: Persona 3{}",
						"{C:inactive,s:0.6}Currently using dev graphics...{}"
					}
				}
			},
        Other={
			DigitalRoot = {
				name = "What's a Digital Root?",
				text = {
						"To calculate the {C:attention}digital root {}of a",
						"set of numbers, add them all together,",
						"and then {C:attention}repeat{} until you have only",
						"{C:attention}one{} digit.",
						"{C:attention}Aces{} have a value of {C:attention}1{}."
				}
			}
		},
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={},
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={},
        high_scores={},
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={
			finalboss_maverick = "Mavericks"
		},
        suits_singular={
			finalboss_maverick = "Maverick"
		},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}