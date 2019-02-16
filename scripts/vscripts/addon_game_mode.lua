--刀塔自走棋
if DAC == nil then
	DAC = class({})
end

require('Timers')
require('Physics')
require('util')
require('barebones')
require('amhc_library/amhc')
require('pathfinder/core/heuristics')
require('pathfinder/core/node')
require('pathfinder/core/path')
require('pathfinder/grid')
require('pathfinder/pathfinder')
require('pathfinder/core/bheap')
require('pathfinder/search/astar')
require('pathfinder/search/bfs')
require('pathfinder/search/dfs')
require('pathfinder/search/dijkstra')
require('pathfinder/search/jps')
require('jump')
require('status_resistance')
LinkLuaModifier("modifier_jump", "jump.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_status_resistance", "status_resistance.lua", LUA_MODIFIER_MOTION_NONE)

function Precache( context )
	local mxx={
		--以前的模型和特效
		"particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",
		"particles/dev/library/base_dust_hit_smoke.vpcf",
		"particles/econ/events/fall_major_2016/teleport_start_fm06_lvl3.vpcf",
		"soundevents/soundevents_dota_ui.vsndevts",
		"particles/econ/events/snowball/snowball_projectile.vpcf",
		"particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",
		"particles/neutral_fx/gnoll_poison_debuff.vpcf",
		"particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf",
		"models/items/courier/teron/teron_flying.vmdl",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts",
		"particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf",
		"particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pu_ti6_heal_hammers.vpcf",
		"particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf",
		"particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf",
		"particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf",
		"particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",
		"particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts",
		"particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts",
		"particles/radiant_fx/radiant_castle002_destruction_a2.vpcf",
		"particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf",
		"particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf",
		"particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf",
		"models/items/courier/duskie/duskie.vmdl",
		"particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts",
		"particles/items2_fx/tranquil_boots_healing.vpcf",
		"particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf",
		"particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_end.vpcf",
		"particles/units/heroes/hero_batrider/batrider_base_attack.vpcf",
		"particles/items_fx/healing_flask_c.vpcf",
		"particles/units/heroes/hero_skeletonking/wraith_king_spirits.vpcf",
		"particles/units/heroes/hero_phoenix/phoenix_supernova_scepter_f.vpcf",
		"particles/radiant_fx/good_barracks_ranged001_lvl3_disintegrate.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts",
		"particles/units/heroes/hero_tinker/tinker_missile.vpcf",
		
		"soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts",
		"soundevents/game_sounds_ui.vsndevts",
		"particles/units/heroes/hero_visage/visage_grave_chill_skel.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts",
		"particles/econ/items/rubick/rubick_puppet_master/rubick_back_puppet_ambient_edge_c.vpcf",
		"particles/newplayer_fx/npx_sleeping.vpcf",
		"particles/generic_gameplay/generic_stunned_old.vpcf",
		"particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
		"particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_projectile_explosion_fire.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts",
		"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_char.vpcf",
		"particles/units/heroes/hero_tiny/tiny_loadout.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts",
		"models/props_structures/tower_good.vmdl",
		"models/props_structures/tower_bad.vmdl",
		"particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_model.vpcf",
		"particles/customgames/capturepoints/cp_allied_wind.vpcf",
		"particles/customgames/capturepoints/cp_wood.vpcf",
		"models/items/courier/hermit_crab/hermit_crab.vmdl",
		"particles/econ/events/ti7/teleport_end_ti7_team1836806.vpcf",
		"particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_ring.vpcf",
		"particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts",
		"particles/addons_gameplay/tower_good_tintable_lamp_end.vpcf",
		"particles/econ/events/ti7/teleport_end_ti7_model.vpcf",
		"particles/units/heroes/hero_shredder/shredder_whirling_death_spin_blades.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts",
		"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		"particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts",
		"particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts",
		"particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf",
		"particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf",
		"particles/units/heroes/hero_sven/sven_spell_gods_strength_small.vpcf",
		"particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts",
		"particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ribbon.vpcf",
		"particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_ground_dust_pyro_gold.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts",
		"particles/dac/explode/land_mine_explode.vpcf",
		"particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_smoke04.vpcf",
		"particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/antimage_manavoid_explode_b_b_ti_5_gold.vpcf",
		"particles/dac/zhayaotong/zhayaotong.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts",
		"particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield_mark.vpcf",
		"particles/dac/ansha/loadout.vpcf",
		"particles/dac/jingzhixianjingplant_ground_disturb.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_techies.vsndevts",
		"particles/generic_gameplay/generic_stunned.vpcf",
		"particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf",


		"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",
		"models/items/wards/eye_of_avernus_ward/eye_of_avernus_ward.vmdl",
		"models/props_structures/dire_ancient_base001_destruction.vmdl",
		"models/props_structures/radiant_ancient001_rock_destruction.vmdl",
		"models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl",
		"models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl",
		"models/props_structures/radiant_ranged_barracks001.vmdl",
		"models/props_structures/dire_barracks_ranged001.vmdl",
		"models/props_structures/radiant_ancient001.vmdl",
		"models/props_structures/dire_ancient_base001.vmdl",
		"models/props_structures/dire_barracks_ranged001_destruction.vmdl",
		"models/props_structures/radiant_ranged_barracks001_destruction.vmdl",
		"effects/damage.vpcf",
		"effects/damage2.vpcf",
		"effects/damage3.vpcf",
		"particles/ui/ui_game_start_hero_spawn.vpcf",
		"particles/base_attacks/ranged_tower_bad_trail.vpcf",
		"particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf",
		"particles/units/heroes/hero_tinker/tinker_laser.vpcf",
		"particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf",
		"soundevents/voscripts/game_sounds_vo_wisp.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts",

		"soundevents/voscripts/game_sounds_vo_lina.vsndevts",
		"particles/econ/items/puck/puck_alliance_set/puck_dreamcoil_waves_aproset.vpcf",
		"particles/econ/items/drow/drow_ti6/drow_ti6_silence_wave_ground_smoke.vpcf",
		"materials/pumpkin.vmdl",
		"models/props_gameplay/boots_of_speed.vmdl",
		"models/props_gameplay/quelling_blade.vmdl",
		"models/props_gameplay/stout_shield.vmdl",
		"models/props_gameplay/tango.vmdl",
		"models/props_gameplay/smoke.vmdl",
		"models/props_gameplay/halloween_candy.vmdl",
		"models/props_gameplay/salve_red.vmdl",
		"models/props_gameplay/mango.vmdl",
		"models/props_gameplay/branch.vmdl",
		"particles/gem/sniper_crosshair.vpcf",
		"particles/radiant_fx/tower_good3_dest_beam.vpcf",
		"particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot.vpcf",
		"soundevents/voscripts/game_sounds_vo_shredder.vsndevts",
		"soundevents/voscripts/game_sounds_vo_rattletrap.vsndevts",
		"soundevents/voscripts/game_sounds_vo_dragon_knight.vsndevts",
		"soundevents/voscripts/game_sounds_vo_death_prophet.vsndevts",
		"soundevents/voscripts/game_sounds_vo_tinker.vsndevts",
		"soundevents/voscripts/game_sounds_vo_lycan.vsndevts",
		"soundevents/voscripts/game_sounds_vo_ursa.vsndevts",
		"soundevents/voscripts/game_sounds_vo_enchantress.vsndevts",
		"soundevents/voscripts/game_sounds_vo_techies.vsndevts",
		"soundevents/voscripts/game_sounds_vo_tiny.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts",
		"soundevents/game_sounds.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lion.vsndevts",
		"soundevents/voscripts/game_sounds_vo_stormspirit.vsndevts",
		"soundevents/game_sounds_roshan_halloween.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts",
		"soundevents/voscripts/game_sounds_vo_doom_bringer.vsndevts",
		"soundevents/voscripts/game_sounds_vo_nyx_assassin.vsndevts",
		"particles/dev/library/base_dust_hit.vpcf",
		"particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl3_ring.vpcf",

		--新的模型和特效
		"soundevents/game_sounds_heroes/game_sounds_lion.vsndevts",
		"particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_axe.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts",
		"particles/units/heroes/hero_lycan/lycan_weapon_blur_b.vpcf",
		"particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
		"particles/units/unit_greevil/loot_greevil_death.vpcf",
		"soundevents/game_sounds_ui.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts",
		"particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",
		"particles/dire_fx/bad_ancient002_destroy_fire.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_axe.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_puck.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts",
		"models/props_gameplay/donkey.vmdl",
		"models/items/courier/bearzky/bearzky.vmdl",
		"models/items/courier/bajie_pig/bajie_pig.vmdl",
		"models/courier/mech_donkey/mech_donkey.vmdl",
		"models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl",
		"models/items/courier/baekho/baekho.vmdl",
		"models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
		"models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
		"models/items/courier/pw_zombie/pw_zombie.vmdl",
		"models/courier/drodo/drodo.vmdl",
		"models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		"particles/generic_gameplay/rune_bounty_prespawn.vpcf",
		"particles/prime/hero_spawn_hero_level_2_base_ring.vpcf",
		"particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor_seedlings_parent.vpcf",
		"particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok_arc.vpcf",
		"particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_crimson_livingarmor.vpcf",
		"particles/units/heroes/hero_puck/puck_base_attack_warmup.vpcf",
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_attack_blur_crit.vpcf",
		"particles/units/heroes/hero_lycan/lycan_weapon_blur_both.vpcf",
		"particles/units/heroes/hero_juggernaut/jugg_attack_blur.vpcf",
		"particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_attack_b.vpcf",
		"particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_attack_a.vpcf",
		"particles/units/heroes/hero_windrunner/wr_taunt_kiss.vpcf",
		"effect/big.vpcf",
		"effect/arrow/1.vpcf",
		"effect/arrow/2.vpcf",
		"effect/arrow/3.vpcf",
		"effect/arrow/4.vpcf",
		"effect/arrow/5.vpcf",
		"effect/arrow/star1.vpcf",
		"effect/arrow/star2.vpcf",
		"effect/arrow/star3.vpcf",
		"particles/error/error.vpcf",
		"particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur.vpcf",
		"particles/units/heroes/hero_lycan/lycan_claw_blur.vpcf",
		"soundevents/voscripts/game_sounds_vo_tusk.vsndevts",
		"soundevents/voscripts/game_sounds_vo_crystalmaiden.vsndevts",
		'models/items/courier/virtus_werebear_t3/virtus_werebear_t3.vmdl',


		"particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_shockwave.vpcf",

		"models/props_gameplay/donkey.vmdl",
		"models/courier/skippy_parrot/skippy_parrot.vmdl",
		"models/courier/smeevil_mammoth/smeevil_mammoth.vmdl",
		"models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
		"models/items/courier/axolotl/axolotl.vmdl",
		"models/items/courier/coco_the_courageous/coco_the_courageous.vmdl",
		"models/items/courier/coral_furryfish/coral_furryfish.vmdl",
		"models/items/courier/corsair_ship/corsair_ship.vmdl",
		"models/items/courier/duskie/duskie.vmdl",
		"models/items/courier/itsy/itsy.vmdl",
		"models/items/courier/jumo/jumo.vmdl",
		"models/items/courier/mighty_chicken/mighty_chicken.vmdl",
		"models/items/courier/nexon_turtle_05_green/nexon_turtle_05_green.vmdl",
		"models/items/courier/pumpkin_courier/pumpkin_courier.vmdl",
		"models/items/courier/pw_ostrich/pw_ostrich.vmdl",
		"models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl",
		"models/items/courier/shagbark/shagbark.vmdl",
		"models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.vmdl",
		"models/items/courier/snail/courier_snail.vmdl",
		"models/items/courier/teron/teron.vmdl",
		"models/items/courier/xianhe_stork/xianhe_stork.vmdl",
		"models/items/courier/starladder_grillhound/starladder_grillhound.vmdl",
		"models/items/courier/pw_zombie/pw_zombie.vmdl",
		"models/items/courier/raiq/raiq.vmdl",
		"models/courier/frog/frog.vmdl",
		"models/courier/godhorse/godhorse.vmdl",
		"models/courier/imp/imp.vmdl",
		"models/courier/mighty_boar/mighty_boar.vmdl",
		"models/items/courier/onibi_lvl_03/onibi_lvl_03.vmdl",
		"models/items/courier/echo_wisp/echo_wisp.vmdl",  --蠕行水母
		"models/courier/sw_donkey/sw_donkey.vmdl", --驴法师new
		"models/items/courier/gnomepig/gnomepig.vmdl", --丰臀公主new
		"models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl",--焚牙树精new
		"models/courier/mechjaw/mechjaw.vmdl",--机械咬人箱new
		"models/items/courier/mole_messenger/mole_messenger.vmdl",--1级矿车老鼠
		"models/courier/doom_demihero_courier/doom_demihero_courier.vmdl",
		"models/courier/huntling/huntling.vmdl",
		"models/courier/minipudge/minipudge.vmdl",
		"models/courier/seekling/seekling.vmdl",
		"models/items/courier/baekho/baekho.vmdl",
		"models/items/courier/basim/basim.vmdl",
		"models/items/courier/devourling/devourling.vmdl",
		"models/items/courier/faceless_rex/faceless_rex.vmdl",
		"models/items/courier/tinkbot/tinkbot.vmdl",
		"models/items/courier/lilnova/lilnova.vmdl",
		 "models/items/courier/amphibian_kid/amphibian_kid.vmdl",
		"models/courier/venoling/venoling.vmdl",
		"models/courier/juggernaut_dog/juggernaut_dog.vmdl",
		"models/courier/otter_dragon/otter_dragon.vmdl",
		"models/items/courier/boooofus_courier/boooofus_courier.vmdl",
		"models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl",
		"models/courier/yak/yak.vmdl",
		"models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl",
		"models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",
		"models/items/courier/waldi_the_faithful/waldi_the_faithful.vmdl",
		"models/items/courier/bajie_pig/bajie_pig.vmdl",
		"models/items/courier/courier_faun/courier_faun.vmdl",
		"models/items/courier/livery_llama_courier/livery_llama_courier.vmdl",
		"models/items/courier/onibi_lvl_10/onibi_lvl_10.vmdl",
		"models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl", --胆小南瓜人
		"models/items/courier/hermit_crab/hermit_crab.vmdl", --螃蟹1
		"models/items/courier/hermit_crab/hermit_crab_boot.vmdl", --螃蟹2
		"models/items/courier/hermit_crab/hermit_crab_shield.vmdl", --螃蟹3
		"models/courier/donkey_unicorn/donkey_unicorn.vmdl", --竭智法师new
		"models/items/courier/white_the_crystal_courier/white_the_crystal_courier.vmdl", --蓝心白隼new
		"models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl",--莲花人new
		"models/courier/beetlejaws/mesh/beetlejaws.vmdl",--甲虫咬人箱new
		"models/courier/smeevil_bird/smeevil_bird.vmdl",
		"models/items/courier/mole_messenger/mole_messenger_lvl4.vmdl",--蜡烛头矿车老鼠
		"models/items/courier/bookwyrm/bookwyrm.vmdl",
		"models/items/courier/captain_bamboo/captain_bamboo.vmdl",
		"models/items/courier/kanyu_shark/kanyu_shark.vmdl",
		"models/items/courier/tory_the_sky_guardian/tory_the_sky_guardian.vmdl",
		"models/items/courier/shroomy/shroomy.vmdl",
		"models/items/courier/courier_janjou/courier_janjou.vmdl",
		"models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
		"models/courier/drodo/drodo.vmdl",
		"models/courier/mech_donkey/mech_donkey.vmdl",
		"models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
		"models/courier/octopus/octopus.vmdl",
		"models/items/courier/scribbinsthescarab/scribbinsthescarab.vmdl",
		"models/courier/defense3_sheep/defense3_sheep.vmdl",
		"models/items/courier/snapjaw/snapjaw.vmdl",
		"models/items/courier/g1_courier/g1_courier.vmdl",
		"models/courier/donkey_trio/mesh/donkey_trio.vmdl",
		"models/items/courier/boris_baumhauer/boris_baumhauer.vmdl",
		"models/courier/baby_rosh/babyroshan.vmdl",
		"models/items/courier/bearzky/bearzky.vmdl",
		"models/items/courier/defense4_radiant/defense4_radiant.vmdl",
		"models/items/courier/defense4_dire/defense4_dire.vmdl",
		"models/items/courier/onibi_lvl_20/onibi_lvl_20.vmdl",
		"models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl", --招财猫
		"models/items/courier/hermit_crab/hermit_crab_necro.vmdl", --螃蟹4
		"models/items/courier/hermit_crab/hermit_crab_travelboot.vmdl", --螃蟹5
		"models/items/courier/hermit_crab/hermit_crab_lotus.vmdl", --螃蟹6
		"models/courier/donkey_ti7/donkey_ti7.vmdl",
		"models/items/courier/shibe_dog_cat/shibe_dog_cat.vmdl", --天猫地狗new
		"models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl",--万圣树群new
		"models/courier/flopjaw/flopjaw.vmdl",--大嘴咬人箱new
		"models/courier/lockjaw/lockjaw.vmdl",--咬人箱洛克new
		"models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",--布狗new
		"models/courier/turtle_rider/turtle_rider.vmdl",
		"models/courier/smeevil_crab/smeevil_crab.vmdl",
		"models/items/courier/mole_messenger/mole_messenger_lvl6.vmdl",--绿钻头矿车老鼠
		"models/courier/navi_courier/navi_courier.vmdl",
		"models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		"models/items/courier/ig_dragon/ig_dragon.vmdl",
		"models/items/courier/lgd_golden_skipper/lgd_golden_skipper.vmdl",
		"models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl",
		"models/items/courier/virtus_werebear_t3/virtus_werebear_t3.vmdl",
		"models/items/courier/throe/throe.vmdl",
		"models/items/courier/vaal_the_animated_constructradiant/vaal_the_animated_constructradiant.vmdl",
		"models/items/courier/vaal_the_animated_constructdire/vaal_the_animated_constructdire.vmdl",
		"models/items/courier/carty/carty.vmdl",
		"models/items/courier/carty_dire/carty_dire.vmdl",
		"models/items/courier/dc_angel/dc_angel.vmdl",
		"models/items/courier/dc_demon/dc_demon.vmdl",
		"models/items/courier/vigilante_fox_green/vigilante_fox_green.vmdl",
		"models/items/courier/bts_chirpy/bts_chirpy.vmdl",
		"models/items/courier/krobeling/krobeling.vmdl",
		"models/items/courier/jin_yin_black_fox/jin_yin_black_fox.vmdl",
		"models/items/courier/jin_yin_white_fox/jin_yin_white_fox.vmdl",
		"models/items/courier/fei_lian_blue/fei_lian_blue.vmdl",
		"models/items/courier/gama_brothers/gama_brothers.vmdl",
		"models/items/courier/onibi_lvl_21/onibi_lvl_21.vmdl",
		"models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes.vmdl", --小飞侠
		"models/items/courier/hermit_crab/hermit_crab_octarine.vmdl", --螃蟹7
		"models/items/courier/hermit_crab/hermit_crab_skady.vmdl", --螃蟹8
		"models/items/courier/hermit_crab/hermit_crab_aegis.vmdl", --螃蟹9
		"models/items/furion/treant_flower_1.vmdl",--绽放树精new
		"models/courier/smeevil_magic_carpet/smeevil_magic_carpet.vmdl",
		"models/items/courier/mole_messenger/mole_messenger_lvl7.vmdl",--绿钻头金矿车老鼠
		"models/items/courier/krobeling_gold/krobeling_gold_flying.vmdl",--金dp
		"models/props_gameplay/donkey.vmdl", 
		"particles/items2_fx/refresher.vpcf",
		"soundevents/game_sounds_items.vsndevts",
		"particles/speechbubbles/speech_voice.vpcf",

		"soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_luna.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_treant.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_viper.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_techies.vsndevts",
		"particles/econ/events/ti5/dagon_ti5.vpcf",
		"particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions_ring_dragon.vpcf",
		"particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_proj_hit_streaks.vpcf",
		"particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf",
		"particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
		"models/props_gameplay/donkey_dire.vmdl",
		"models/props_gameplay/donkey_dire_wings.vmdl",
		"models/courier/baby_rosh/babyroshan_winter18.vmdl",
		"effect/dizuo/1.vpcf",
		"soundevents/voscripts/game_sounds_vo_lone_druid.vsndevts",
		"soundevents/voscripts/game_sounds_vo_furion.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts",
		"soundevents/voscripts/game_sounds_vo_terrorblade.vsndevts",
		"particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf",
		"soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts",
		"models/items/kunkka/kunkka_immortal/kunkka_shark_immortal.vmdl",
		"models/courier/frull/frull_courier.vmdl",
		"models/items/courier/amaterasu/amaterasu.vmdl",
		"models/items/courier/chocobo/chocobo.vmdl",
		"models/items/courier/flightless_dod/flightless_dod.vmdl",
		"models/items/courier/frostivus2018_courier_serac_the_seal/frostivus2018_courier_serac_the_seal.vmdl",
		"models/items/courier/jumo_dire/jumo_dire.vmdl",
		"models/items/courier/pangolier_squire/pangolier_squire.vmdl",
		"models/items/courier/sltv_10_courier/sltv_10_courier.vmdl",
		"models/items/courier/nian_courier/nian_courier.vmdl",
		"models/items/courier/nilbog/nilbog.vmdl",
		"particles/items_fx/blink_dagger_end.vpcf",
	} 
    print("Precache...")
	local t=table.maxn(mxx)
	for i=1,t do
		if string.find(mxx[i], "vpcf") then
			PrecacheResource( "particle",  mxx[i], context)
		end
		if string.find(mxx[i], "vmdl") then 	
			PrecacheResource( "model",  mxx[i], context)
		end
		if string.find(mxx[i], "vsndevts") then
			PrecacheResource( "soundfile",  mxx[i], context)
		end
    end
    PrecacheUnitByNameSync("chess_tusk", context)
    PrecacheUnitByNameSync("chess_cm", context)
    PrecacheUnitByNameSync("chess_axe", context)
    PrecacheUnitByNameSync("chess_eh", context)
    PrecacheUnitByNameSync("chess_om", context)
    PrecacheUnitByNameSync("chess_am", context)
    PrecacheUnitByNameSync("chess_clock", context)
    PrecacheUnitByNameSync("chess_ss", context)
    PrecacheUnitByNameSync("chess_bh", context)
    PrecacheUnitByNameSync("chess_wd", context)
    PrecacheUnitByNameSync("chess_bat", context)
    PrecacheUnitByNameSync("chess_tk", context)
    PrecacheUnitByNameSync("chess_bm", context)
    PrecacheUnitByNameSync("chess_jugg", context)
    PrecacheUnitByNameSync("chess_lyc", context)
    PrecacheUnitByNameSync("chess_shredder", context)
    PrecacheUnitByNameSync("chess_pa", context)
    PrecacheUnitByNameSync("chess_puck", context)
    PrecacheUnitByNameSync("chess_slardar", context)
    PrecacheUnitByNameSync("chess_ck", context)
    PrecacheUnitByNameSync("chess_luna", context)
    PrecacheUnitByNameSync("chess_tp", context)
    PrecacheUnitByNameSync("chess_dr", context)
    PrecacheUnitByNameSync("chess_light", context)
    PrecacheUnitByNameSync("chess_razor", context)
    PrecacheUnitByNameSync("chess_ok", context)
    PrecacheUnitByNameSync("chess_wr", context)
    PrecacheUnitByNameSync("chess_sk", context)
    PrecacheUnitByNameSync("chess_abaddon", context)
    PrecacheUnitByNameSync("chess_slark", context)
    PrecacheUnitByNameSync("chess_sniper", context)
    PrecacheUnitByNameSync("chess_sf", context)
    PrecacheUnitByNameSync("chess_dk", context)
    PrecacheUnitByNameSync("chess_viper", context)
    PrecacheUnitByNameSync("chess_kunkka", context)
    PrecacheUnitByNameSync("chess_doom", context)
    PrecacheUnitByNameSync("chess_lina", context)
    PrecacheUnitByNameSync("chess_troll", context)
    PrecacheUnitByNameSync("chess_veno", context)
    PrecacheUnitByNameSync("chess_nec", context)
    PrecacheUnitByNameSync("chess_ta", context)
    PrecacheUnitByNameSync("chess_medusa", context)
    PrecacheUnitByNameSync("chess_disruptor", context)
    PrecacheUnitByNameSync("chess_ga", context)
    PrecacheUnitByNameSync("chess_gyro", context)
    PrecacheUnitByNameSync("chess_lich", context)
    PrecacheUnitByNameSync("chess_qop", context)
    PrecacheUnitByNameSync("chess_th", context)
    PrecacheUnitByNameSync("chess_enigma", context)
    PrecacheUnitByNameSync("chess_tech", context)
    PrecacheUnitByNameSync("chess_ld", context)
    PrecacheUnitByNameSync("chess_fur", context)

    PrecacheUnitByNameSync("chess_tiny", context)
    PrecacheUnitByNameSync("chess_morph", context)
    PrecacheUnitByNameSync("chess_tb", context)
    PrecacheUnitByNameSync("chess_nec_ssr", context)
    PrecacheUnitByNameSync("chess_ck_ssr", context)

    PrecacheUnitByNameSync("chess_kael", context)
    PrecacheUnitByNameSync("chess_zeus", context)
    PrecacheUnitByNameSync("chess_sven", context)


    print("Precache OK")
end

function Activate()
	GameRules:GetGameModeEntity().AddonTemplate = DAC()
	GameRules:GetGameModeEntity().AddonTemplate:InitGameMode()
end
--1、初始化变量和监听
function DAC:InitGameMode()
	AMHCInit()
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, 1 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, 1 )

	GameRules:GetGameModeEntity().team_color = {
		[4] = {r=255,g=0,b=0},
		[6] = {r=0,g=46,b=197},
		[7] = {r=128,g=128,b=128},
		[8] = {r=255,g=255,b=192},
		[9] = {r=255,g=192,b=64},
		[10] = {r=17,g=232,b=234},
		[11] = {r=255,g=100,b=200},
		[12] = {r=255,g=156,b=156},
		[13] = {r=255,g=0,b=255},
	}

	-- PlayerResource:SetCustomPlayerColor(0, 0,0,255)
	-- PlayerResource:SetCustomPlayerColor(1, 0,0,255)

	-- SetTeamCustomHealthbarColor(DOTA_TEAM_NEUTRALS, 255,0,0)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_1, 0,192,0)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_2, 128,128,128)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_3, 255,255,192)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_4, 255,192,64)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_5, 17,232,234)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_6, 255,100,200)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_7, 255,156,156)
	-- SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_8, 255,0,255)
	
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_1, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_2, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_3, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_4, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_5, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_6, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_7, 128,255,128)
	SetTeamCustomHealthbarColor(DOTA_TEAM_CUSTOM_8, 128,255,128)

    ListenToGameEvent("player_connect_full", Dynamic_Wrap(DAC,"OnPlayerConnectFull" ),self)
    ListenToGameEvent("player_disconnect", Dynamic_Wrap(DAC, "OnPlayerDisconnect"), self)
    ListenToGameEvent("player_chat",Dynamic_Wrap(DAC,"OnPlayerChat"),self)
    ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(DAC,"OnPlayerPickHero"),self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(DAC, "OnEntityKilled"), self)
    ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(DAC,"OnPlayerGainedLevel"), self)

    --CustomGameEventManager:RegisterListener("gather_steam_ids", Dynamic_Wrap(DAC, "OnGatherSteamIds") )
    CustomGameEventManager:RegisterListener("dac_pick_chess", Dynamic_Wrap(DAC, "OnKeyboardPickChess") )
    CustomGameEventManager:RegisterListener("battle_deck", Dynamic_Wrap(DAC, "OnDeckReiceived") )
    CustomGameEventManager:RegisterListener("select_chess", Dynamic_Wrap(DAC, "OnChessSelected") )
    CustomGameEventManager:RegisterListener("pick_chess_position", Dynamic_Wrap(DAC, "OnPickChessPosition") )
    CustomGameEventManager:RegisterListener("cancel_pick_chess_position", Dynamic_Wrap(DAC, "OnCancelPickChessPosition") )

    CustomGameEventManager:RegisterListener("match_details_updated", Dynamic_Wrap(DAC, "OnMatchDetailsUpdated") )

    CustomGameEventManager:RegisterListener("dac_refresh_chess", Dynamic_Wrap(DAC, "OnRefreshChess") )
    CustomGameEventManager:RegisterListener("catch_crab", Dynamic_Wrap(DAC, "OnCatchCrab") )
    CustomGameEventManager:RegisterListener("unlock_chess", Dynamic_Wrap(DAC, "OnUnlockChess") )
    CustomGameEventManager:RegisterListener("lock_chess", Dynamic_Wrap(DAC, "OnLockChess") )
    CustomGameEventManager:RegisterListener("change_onduty_hero", Dynamic_Wrap(DAC, "OnChangeOndutyHero") )
    CustomGameEventManager:RegisterListener("preview_effect", Dynamic_Wrap(DAC, "OnPreviewEffect") )

    GameRules:GetGameModeEntity().battle_round = 1
    GameRules:GetGameModeEntity().steamidlist = ''
    GameRules:GetGameModeEntity().steamidlist_heroindex = ''
    GameRules:GetGameModeEntity().steamid2playerid = {}
    GameRules:GetGameModeEntity().playerid2steamid = {}
    GameRules:GetGameModeEntity().steamid2name = {}
    GameRules:GetGameModeEntity().stat_info = {}
    GameRules:GetGameModeEntity().show_damage = false
    GameRules:GetGameModeEntity().upload_lineup = {}
    GameRules:GetGameModeEntity().upload_detail_stat = {}
    GameRules:GetGameModeEntity().connect_state = {
	    [0] = false,
	    [1] = false,
	    [2] = false,
	    [3] = false,
	    [4] = false,
	    [5] = false,
	    [6] = false,
	    [7] = false,
	}
    GameRules:GetGameModeEntity().battle_boss = {
	    [1] = {  --天辉卫士
	    	[1] = {x=4,y=8,enemy='pve_melee_good'},
	    	[2] = {x=5,y=8,enemy='pve_melee_good'},
		},
		[2] = {  --天辉中军
	    	[1] = {x=4,y=6,enemy='pve_melee_good_mega'},
	    	[2] = {x=5,y=8,enemy='pve_ranged_good'},
	    	[3] = {x=3,y=8,enemy='pve_ranged_good'},
		},
		[3] = {  --天辉统帅
	    	[1] = {x=4,y=6,enemy='pve_melee_good_mega'},
	    	[2] = {x=5,y=6,enemy='pve_melee_good_mega'},
	    	[3] = {x=4,y=8,enemy='pve_ranged_good'},
	    	[4] = {x=5,y=8,enemy='pve_ranged_good'},
	    	[5] = {x=3,y=7,enemy='pve_melee_good'},
	    	[6] = {x=6,y=7,enemy='pve_melee_good'},
		},
		[10] = {  --岩石傀儡
			[1] = {x=4,y=6,enemy='pve_stone_a'},
	    	[2] = {x=2,y=7,enemy='pve_stone_b'},
	    	[3] = {x=6,y=7,enemy='pve_stone_b'},
		},
		[15] = {  --群狼
			[1] = {x=4,y=6,enemy='pve_wolf_big'},
			[2] = {x=5,y=8,enemy='pve_wolf_small'},
	    	[3] = {x=3,y=8,enemy='pve_wolf_small'},
	    	[4] = {x=2,y=7,enemy='pve_wolf_small'},
	    	[5] = {x=6,y=7,enemy='pve_wolf_small'},
		},
		[20] = {  --夺命双熊
			[1] = {x=4,y=6,enemy='pve_bear_a'},
	    	[2] = {x=2,y=7,enemy='pve_bear_b'},
		},
		[25] = {  --愤怒的枭兽
			[1] = {x=2,y=7,enemy='pve_vulture_a'},
			[2] = {x=7,y=7,enemy='pve_vulture_b'},
		},
		[30] = {  --雷隐兽
			[1] = {x=4,y=6,enemy='pve_leishou_a'},
			[2] = {x=3,y=7,enemy='pve_leishou_b'},
			[3] = {x=5,y=7,enemy='pve_leishou_b'},
		},
		[35] = {  --黑龙王
			[1] = {x=4,y=5,enemy='pve_black_dragon'},
		},
		[40] = {  --巨魔部落
			[1] = {x=3,y=6,enemy='pve_troll_dark_a'},
			[2] = {x=4,y=6,enemy='pve_troll_dark_a'},
			[3] = {x=5,y=6,enemy='pve_troll_dark_a'},
			[4] = {x=6,y=6,enemy='pve_troll_dark_a'},
			[5] = {x=3,y=8,enemy='pve_troll_dark_b'},
			[6] = {x=6,y=8,enemy='pve_troll_dark_c'},
		},
		[45] = {  --年兽
			[1] = {x=4,y=7,enemy='pve_nian'},
		},
		[50] = {  --肉山大魔王
			[1] = {x=4,y=7,enemy='pve_roshan'},
		},
	}
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    GameRules:GetGameModeEntity().heroindex2steamid = {}
    GameRules:GetGameModeEntity().cloudlineup = nil
    GameRules:GetGameModeEntity().steamid2heroindex = {}

    GameRules:GetGameModeEntity().userid2player = {}
	GameRules:GetGameModeEntity().team2playerid = {}
	GameRules:GetGameModeEntity().playerid2team = {}

	GameRules:GetGameModeEntity().START_TIME = nil
    GameRules:GetGameModeEntity().player_levels = {}
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(10)
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(
		{
			[1] = 0,
			[2] = 1,
			[3] = 2,
			[4] = 4,
			[5] = 8,
			[6] = 16,
			[7] = 32,
			[8] = 56,--64,
			[9] = 88,--112,
			[10] = 128,--176,
		}
	)

    GameRules:GetGameModeEntity().unit = {
	    [6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
    }
    GameRules:GetGameModeEntity().mychess = {
    	[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	GameRules:GetGameModeEntity().to_be_destory_list = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	GameRules:GetGameModeEntity().game_status = 0
	GameRules:GetGameModeEntity().prepare_timer = 35
	GameRules:GetGameModeEntity().battle_timer = 60
    GameRules:GetGameModeEntity().myself = false
	GameRules:GetGameModeEntity().is_stop = false
	GameRules:GetGameModeEntity().isConnected = {}
	GameRules:GetGameModeEntity().is_game_started =false
	GameRules:GetGameModeEntity().is_game_ended =false

	--默认卡池参数
	GameRules:GetGameModeEntity().CHESS_POOL_SIZE = 5
	GameRules:GetGameModeEntity().CHESS_INIT_COUNT = {
		[1] = 9,
		[2] = 6,
		[3] = 5,
		[4] = 3,
		[5] = 2,
	}


    print("InitGameMode")

    CustomNetTables:SetTableValue( "dac_table", "curtain_tips", { text = "正在初始化地图", hehe = RandomInt(1,1000)})


    GameRules:GetGameModeEntity().hero = {}
    GameRules:GetGameModeEntity().battleid = nil
    GameRules:GetGameModeEntity().ended = false
    GameRules:GetGameModeEntity().playerid2hero = {}
	GameRules:GetGameModeEntity().teamid2hero = {}
	

	GameRules:GetGameModeEntity().base_vector = {
		[6] = Vector(-2496,1728,128),
		[7] = Vector(-448,1728,128),
		[8] = Vector(1600,1728,128),
		[9] = Vector(1600,-320,128),
		[10] = Vector(1600,-2368,128),
		[11] = Vector(-448,-2368,128),
		[12] = Vector(-2496,-2368,128),
		[13] = Vector(-2496,-320,128),
	}
	GameRules:GetGameModeEntity().hand = {
		[6] = {0,0,0,0,0,0,0,0},
		[7] = {0,0,0,0,0,0,0,0},
		[8] = {0,0,0,0,0,0,0,0},
		[9] = {0,0,0,0,0,0,0,0},
		[10] = {0,0,0,0,0,0,0,0},
		[11] = {0,0,0,0,0,0,0,0},
		[12] = {0,0,0,0,0,0,0,0},
		[13] = {0,0,0,0,0,0,0,0},
	}
	GameRules:GetGameModeEntity().counterpart = {}
	GameRules:GetGameModeEntity().lastrandomn = 0
	GameRules:GetGameModeEntity().population = {
		[6] = 0,
		[7] = 0,
		[8] = 0,
		[9] = 0,
		[10] = 0,
		[11] = 0,
		[12] = 0,
		[13] = 0,
	}
	GameRules:GetGameModeEntity().population_max = {
		[6] = 1,
		[7] = 1,
		[8] = 1,
		[9] = 1,
		[10] = 1,
		[11] = 1,
		[12] = 1,
		[13] = 1,
	}
	--给第i个人提供第j个场地的视野
	GameRules:GetGameModeEntity().lights = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	GameRules:GetGameModeEntity().damage_stat = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	GameRules:GetGameModeEntity().chess_list_by_mana = {
		[1] = {'chess_tusk','chess_axe','chess_eh','chess_om','chess_clock','chess_ss','chess_bh','chess_bat','chess_dr','chess_tk','chess_am','chess_tiny'},
		[2] = {'chess_bm','chess_jugg','chess_shredder','chess_puck','chess_ck','chess_slardar','chess_luna','chess_tp','chess_qop','chess_wd','chess_cm','chess_fur','chess_morph'},
		[3] = {'chess_ok','chess_razor','chess_wr','chess_sk','chess_abaddon','chess_slark','chess_sniper','chess_sf','chess_viper','chess_lyc','chess_pa','chess_veno','chess_lina','chess_tb'},
		[4] = {'chess_kunkka','chess_doom','chess_troll','chess_nec','chess_ta','chess_medusa','chess_disruptor','chess_ga','chess_dk','chess_light','chess_ld'},
		[5] = {'chess_gyro','chess_lich','chess_th','chess_enigma','chess_tech'},
	}
	GameRules:GetGameModeEntity().chess_list_ssr = {'chess_nec_ssr','chess_ck_ssr'}
	GameRules:GetGameModeEntity().chess_2_mana = {
		chess_tusk = 1,
		chess_axe = 1,
		chess_eh = 1,
		chess_om = 1,
		chess_clock = 1,
		chess_ss = 1,
		chess_bh = 1,
		chess_bat = 1,
		chess_dr = 1,
		chess_tk = 1,
		chess_bm = 2,
		chess_jugg = 2,
		chess_shredder = 2,
		chess_puck = 2,
		chess_ck = 2,
		chess_slardar = 2,
		chess_luna = 2,
		chess_tp = 2,
		chess_qop = 2,
		chess_am = 1,
		chess_wd = 2,
		chess_cm = 2,
		chess_light = 4,
		chess_ok = 3,
		chess_razor = 3,
		chess_wr = 3,
		chess_sk = 3,
		chess_abaddon = 3,
		chess_slark = 3,
		chess_sniper = 3,
		chess_sf = 3,
		chess_viper = 3,
		chess_lyc = 3,
		chess_pa = 3,
		chess_kunkka = 4,
		chess_doom = 4,
		chess_lina = 3,
		chess_troll = 4,
		chess_veno = 3,
		chess_nec = 4,
		chess_ta = 4,
		chess_medusa = 4,
		chess_disruptor = 4,
		chess_ga = 4,
		chess_dk = 4,
		chess_gyro = 5,
		chess_lich = 5,
		chess_th = 5,
		chess_enigma = 5,
		chess_tech = 5,
		chess_fur = 2,
		chess_ld = 4,
		--
		chess_tiny = 1,
		chess_tb = 3,
		chess_morph = 2,
		chess_nec_ssr = 10,
		chess_ck_ssr = 15,
		chess_kael = 3,
		chess_zeus = 5,
		chess_sven = 5,
	}
	GameRules:GetGameModeEntity().chess_pool = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
	}
	GameRules:GetGameModeEntity().chess_gailv = {
		[1] = { [101] = 2 },
		[2] = { [70] = 2 },
		[3] = { [60] = 2, [95] = 3 },
		[4] = { [50] = 2, [85] = 3 },
		[5] = { [40] = 2, [75] = 3, [98] = 4 },
		[6] = { [33] = 2, [63] = 3, [93] = 4 },
		[7] = { [30] = 2, [60] = 3, [90] = 4 },
		[8] = { [24] = 2, [54] = 3, [84] = 4, [99] = 5 },
		[9] = { [22] = 2, [52] = 3, [77] = 4, [97] = 5 },
		[10] = { [19] = 2, [44] = 3, [69] = 4, [94] = 5 },
	}
	GameRules:GetGameModeEntity().drop_item_gailv = {
		[1] = { [80] = 1},
		[2] = { [60] = 1},
		[3] = { [50] = 1},
		[4] = { [40] = 1, [80] = 2},
		[5] = { [40] = 1, [60] = 2},
		[6] = { [30] = 1, [60] = 2, [90] = 3},
		[7] = { [20] = 1, [50] = 2, [80] = 3},
		[8] = { [0] = 1, [20] = 2, [60] = 3, [90] = 4},
		[9] = { [0] = 1, [10] = 2, [50] = 3, [80] = 4},
	}
	GameRules:GetGameModeEntity().chess_ability_list = {
		chess_cm = 'cm_mana_aura',
		chess_axe = 'axe_berserkers_call',
		chess_dr = 'shooter_aura',
		chess_eh = 'enchantress_natures_attendants',
		chess_om = 'ogre_magi_bloodlust',
		chess_tusk = 'tusk_walrus_punch',
		chess_bm = 'beastmaster_wild_axes',
		chess_jugg = 'juggernaut_blade_fury',
		chess_lyc = 'lyc_wolf',
		chess_shredder = 'shredder_whirling_death',
		chess_tk = 'a108',
		chess_light = 'keeper_of_the_light_illuminate',
		chess_ok = 'omniknight_purification',
		chess_razor = 'razor_plasma_field',
		chess_wr = 'windrunner_powershot',
		chess_doom = 'doom_bringer_doom',
		chess_kunkka = 'kunkka_ghostship',
		chess_lina = 'lina_laguna_blade',
		chess_troll = 'troll_warlord_fervor',
		chess_veno = 'veno_ward',
		chess_gyro = 'gyrocopter_call_down',
		chess_jakiro = 'jakiro_macropyre',
		chess_lich = 'lich_chain_frost',
		chess_qop = 'queenofpain_scream_of_pain',
		chess_th = 'tidehunter_ravage',
		--
		chess_am = 'antimage_mana_break',
		chess_bh = 'bounty_hunter_shuriken_toss',
		chess_wd = 'witch_doctor_paralyzing_cask',
		chess_clock = 'rattletrap_battery_assault',
		chess_ss = 'shadow_shaman_voodoo',
		chess_pa = 'phantom_assassin_coup_de_grace',
		chess_puck = 'puck_illusory_orb',
		chess_slardar = 'slardar_amplify_damage',
		chess_ck = 'chaos_knight_chaos_bolt',
		chess_abaddon = 'abaddon_aphotic_shield',
		chess_sk = 'sandking_burrowstrike',
		chess_slark = 'slark_shadow_dance',
		chess_sniper = 'sniper_assassinate',
		chess_nec = 'necrolyte_death_pulse',
		chess_ta = 'templar_assassin_refraction',
		chess_enigma = 'enigma_midnight_pulse',
		--
		chess_bat = 'batrider_sticky_napalm',
		chess_luna = 'luna_moon_glaive',
		chess_tp = 'treant_leech_seed',
		chess_sf = 'nevermore_requiem',
		chess_dk = 'dragon_knight_elder_dragon_form',
		chess_viper = 'viper_viper_strike',
		chess_medusa = 'medusa_stone_gaze',
		chess_disruptor = 'disruptor_static_storm',
		chess_ga = 'alchemist_acid_spray',
		chess_tech = 'chess_tech_bomb',
		--
		chess_fur = 'fur_tree',
		chess_ld = 'ld_bear',
		--
		chess_nec_ssr = 'nec_ssr_scythe',
		chess_morph = 'morphling_waveform',
		chess_tb = 'tb_mohua',
		chess_tiny = 'tiny_touzhi',


		chess_cm1 = 'cm_mana_aura',
		chess_axe1 = 'axe_berserkers_call',
		chess_dr1 = 'shooter_aura',
		chess_eh1 = 'enchantress_natures_attendants',
		chess_om1 = 'ogre_magi_bloodlust',
		chess_tusk1 = 'tusk_walrus_punch',
		chess_bm1 = 'beastmaster_wild_axes',
		chess_jugg1 = 'juggernaut_blade_fury',
		chess_lyc1 = 'lyc_wolf',
		chess_shredder1 = 'shredder_whirling_death',
		chess_tk1 = 'a108',
		chess_light1 = 'keeper_of_the_light_illuminate',
		chess_ok1 = 'omniknight_purification',
		chess_razor1 = 'razor_plasma_field',
		chess_wr1 = 'windrunner_powershot',
		chess_doom1 = 'doom_bringer_doom',
		chess_kunkka1 = 'kunkka_ghostship',
		chess_lina1 = 'lina_laguna_blade',
		chess_troll1 = 'troll_warlord_fervor',
		chess_veno1 = 'veno_ward',
		chess_gyro1 = 'gyrocopter_call_down',
		chess_jakiro1 = 'jakiro_macropyre',
		chess_lich1 = 'lich_chain_frost',
		chess_qop1 = 'queenofpain_scream_of_pain',
		chess_th1 = 'tidehunter_ravage',
		--
		chess_am1 = 'antimage_mana_break',
		chess_bh1 = 'bounty_hunter_shuriken_toss',
		chess_wd1 = 'witch_doctor_paralyzing_cask',
		chess_clock1 = 'rattletrap_battery_assault',
		chess_ss1 = 'shadow_shaman_voodoo',
		chess_pa1 = 'phantom_assassin_coup_de_grace',
		chess_puck1 = 'puck_illusory_orb',
		chess_slardar1 = 'slardar_amplify_damage',
		chess_ck1 = 'chaos_knight_chaos_bolt',
		chess_abaddon1 = 'abaddon_aphotic_shield',
		chess_sk1 = 'sandking_burrowstrike',
		chess_slark1 = 'slark_shadow_dance',
		chess_sniper1 = 'sniper_assassinate',
		chess_nec1 = 'necrolyte_death_pulse',
		chess_ta1 = 'templar_assassin_refraction',
		chess_enigma1 = 'enigma_midnight_pulse',
		--
		chess_bat1 = 'batrider_sticky_napalm',
		chess_luna1 = 'luna_moon_glaive',
		chess_tp1 = 'treant_leech_seed',
		chess_sf1 = 'nevermore_requiem',
		chess_dk1 = 'dragon_knight_elder_dragon_form',
		chess_viper1 = 'viper_viper_strike',
		chess_medusa1 = 'medusa_stone_gaze',
		chess_disruptor1 = 'disruptor_static_storm',
		chess_ga1 = 'alchemist_acid_spray',
		chess_tech1 = 'chess_tech_bomb',
		--
		chess_fur1 = 'fur_tree',
		chess_ld1 = 'ld_bear',
		--
		chess_morph1 = 'morphling_waveform',
		chess_tb1 = 'tb_mohua',
		chess_tiny1 = 'tiny_touzhi',


		chess_cm11 = 'cm_mana_aura',
		chess_axe11 = 'axe_berserkers_call',
		chess_dr11 = 'shooter_aura',
		chess_eh11 = 'enchantress_natures_attendants',
		chess_om11 = 'ogre_magi_bloodlust',
		chess_tusk11 = 'tusk_walrus_punch',
		chess_bm11 = 'beastmaster_wild_axes',
		chess_jugg11 = 'juggernaut_blade_fury',
		chess_lyc11 = 'lyc_wolf',
		chess_shredder11 = 'shredder_whirling_death',
		chess_tk11 = 'a108',
		chess_light11 = 'keeper_of_the_light_illuminate',
		chess_ok11 = 'omniknight_purification',
		chess_razor11 = 'razor_plasma_field',
		chess_wr11 = 'windrunner_powershot',
		chess_doom11 = 'doom_bringer_doom',
		chess_kunkka11 = 'kunkka_ghostship',
		chess_lina11 = 'lina_laguna_blade',
		chess_troll11 = 'troll_warlord_fervor',
		chess_veno11 = 'veno_ward',
		chess_gyro11 = 'gyrocopter_call_down',
		chess_jakiro11 = 'jakiro_macropyre',
		chess_lich11 = 'lich_chain_frost',
		chess_qop11 = 'queenofpain_scream_of_pain',
		chess_th11 = 'tidehunter_ravage',
		--
		chess_am11 = 'antimage_mana_break',
		chess_bh11 = 'bounty_hunter_shuriken_toss',
		chess_wd11 = 'witch_doctor_paralyzing_cask',
		chess_clock11 = 'rattletrap_battery_assault',
		chess_ss11 = 'shadow_shaman_voodoo',
		chess_pa11 = 'phantom_assassin_coup_de_grace',
		chess_puck11 = 'puck_illusory_orb',
		chess_slardar11 = 'slardar_amplify_damage',
		chess_ck11 = 'chaos_knight_chaos_bolt',
		chess_abaddon11 = 'abaddon_aphotic_shield',
		chess_sk11 = 'sandking_burrowstrike',
		chess_slark11 = 'slark_shadow_dance',
		chess_sniper11 = 'sniper_assassinate',
		chess_nec11 = 'necrolyte_death_pulse',
		chess_ta11 = 'templar_assassin_refraction',
		chess_enigma11 = 'enigma_midnight_pulse',
		--
		chess_bat11 = 'batrider_sticky_napalm',
		chess_luna11 = 'luna_moon_glaive',
		chess_tp11 = 'treant_leech_seed',
		chess_sf11 = 'nevermore_requiem',
		chess_dk11 = 'dragon_knight_elder_dragon_form',
		chess_viper11 = 'viper_viper_strike',
		chess_medusa11 = 'medusa_stone_gaze',
		chess_disruptor11 = 'disruptor_static_storm',
		chess_ga11 = 'alchemist_acid_spray',
		chess_tech11 = 'chess_tech_bomb',
		--
		chess_fur11 = 'fur_tree',
		chess_ld11 = 'ld_bear',
		--
		chess_morph11 = 'morphling_waveform',
		chess_tb11 = 'tb_mohua',
		chess_tiny11 = 'tiny_touzhi',

		chess_ck_ssr = 'ck_illusion',
	}
	--释放技能：0=被动技能，1=单位目标，2=无目标，3=点目标，4=自己目标，5=近身单位目标，6=先知周边树人，7=随机友军目标（嗜血术），8=随机周围空地目标（炸弹人），9=血量百分比最低的队友，10=等级最高的敌人（末日），11=沙王穿刺
	GameRules:GetGameModeEntity().ability_behavior_list = {
			axe_berserkers_call = 2,
			crystal_maiden_brilliance_aura = 0,
			enchantress_natures_attendants = 2,
			ogre_magi_ignite = 1,
			ogre_magi_bloodlust = 7,
			tusk_walrus_punch = 5,
			beastmaster_wild_axes = 3,
			juggernaut_blade_fury = 2,
			lyc_wolf = 2,
			shredder_whirling_death = 2,
			a108 = 2,
			shooter_aura = 0,
			keeper_of_the_light_illuminate = 3,
			omniknight_purification = 9,
			razor_plasma_field = 2,
			windrunner_powershot = 3,
			doom_bringer_doom = 10,
			kunkka_ghostship = 3,
			lina_laguna_blade = 10,
			troll_warlord_whirling_axes_melee = 2,
			troll_warlord_whirling_axes_ranged = 1,
			troll_warlord_fervor = 0,
			venomancer_poison_nova = 2,
			veno_ward = 8,
			gyrocopter_call_down = 3,
			jakiro_macropyre = 3,
			lich_chain_frost = 1,
			queenofpain_scream_of_pain = 2,
			tidehunter_ravage = 2,
			antimage_mana_break = 0,
			bounty_hunter_shuriken_toss = 1,
			witch_doctor_paralyzing_cask = 1,
			rattletrap_battery_assault = 2,
			shadow_shaman_voodoo = 1,
			phantom_assassin_coup_de_grace = 0,
			puck_illusory_orb = 3,
			slardar_amplify_damage = 1,
			chaos_knight_chaos_bolt = 1,
			abaddon_aphotic_shield = 9,
			bump = 11,
			slark_shadow_dance = 2,
			sniper_assassinate = 1,
			necrolyte_death_pulse = 2,
			templar_assassin_refraction = 2,
			enigma_midnight_pulse = 3,
			--
			batrider_sticky_napalm = 3,
			batrider_firefly = 6,
			luna_moon_glaive = 0,
			treant_leech_seed = 5,
			nevermore_requiem = 2,
			dragon_knight_elder_dragon_form = 2,
			viper_viper_strike = 1,
			medusa_stone_gaze = 2,
			disruptor_static_storm = 3,
			alchemist_acid_spray = 3,
			chess_tech_bomb = 8,
			sven_great_cleave = 0,
			fur_tree = 6,
			ld_bear = 8,
			--
			nec_ssr_scythe = 1,
			morphling_waveform = 11,
			sandking_burrowstrike = 11,
			tb_mohua = 2,
			tiny_touzhi = 12,
			ck_illusion = 2,
		}
	
	--组合技技能ability
	--组合技条件condition：0=只有唯一1个同职业/种族的友军，1~3=需要1~3名同职业/种族的友军
	--组合技类型type：0=自身有效果，1=所有同职业/种族的友军的有效果，2=所有友军有效果，3=所有敌军有效果，4=随机一个友军有效果，5=随机一个敌军有效果
	GameRules:GetGameModeEntity().combo_ability_type = {
		--职业技能
		is_warrior = { ability = 'is_warrior_buff', condition = 3, type = 1 },
		is_warrior1 = { ability = 'is_warrior_buff_plus', condition = 6, type = 1 },
		is_warrior11 = { ability = 'is_warrior_buff_plus_plus', condition = 9, type = 1 },
		is_mage = { ability = 'is_mage_buff', condition = 3, type = 3 },
		is_mage1 = { ability = 'is_mage_buff_plus', condition = 6, type = 3 },
		is_warlock = { ability = 'is_warlock_buff', condition = 3, type = 2 },
		is_warlock1 = { ability = 'is_warlock_buff_plus', condition = 6, type = 2 },
		is_mech = { ability = 'is_mech_buff', condition = 2, type = 1 },
		is_mech1 = { ability = 'is_mech_buff_plus', condition = 4, type = 1 },
		is_assassin = { ability = 'is_assassin_buff', condition = 3, type = 1 },
		is_assassin1 = { ability = 'is_assassin_buff_plus', condition = 6, type = 1 },
		is_hunter = { ability = 'is_hunter_buff', condition = 3, type = 1 },
		is_hunter1 = { ability = 'is_hunter_buff_plus', condition = 6, type = 1 },
		is_knight = { ability = 'is_knight_buff', condition = 2, type = 1 },
		is_knight1 = { ability = 'is_knight_buff_plus', condition = 4, type = 1 },
		is_knight11 = { ability = 'is_knight_buff_plus_plus', condition = 6, type = 1 },
		is_shaman = {condition = 2 , type = 5},
		is_demonhunter = {condition = 1 , type = 1},
		is_demonhunter1 = {condition = 2 , type = 1},

		--种族技能
		is_troll = { ability = 'is_troll_buff', condition = 2, type = 1 },
		is_troll1 = { ability = 'is_troll_buff_plus', condition = 4, type = 2 },
		is_beast = { ability = 'is_beast_buff', condition = 2, type = 2 },
		is_beast1 = { ability = 'is_beast_buff_plus', condition = 4, type = 2 },
		is_beast11 = { ability = 'is_beast_buff_plus_plus', condition = 6, type = 2 },
		is_elf = { ability = 'is_elf_buff', condition = 3, type = 1 },
		is_elf1 = { ability = 'is_elf_buff_plus', condition = 6, type = 1 },
		is_human = { ability = 'is_human_buff', condition = 2, type = 1 },
		is_human1 = { ability = 'is_human_buff_plus', condition = 4, type = 1 },
		is_human11 = { ability = 'is_human_buff_plus_plus', condition = 6, type = 1 },
		is_undead = { ability = 'is_undead_buff', condition = 2, type = 3 },
		is_undead1 = { ability = 'is_undead_buff_plus', condition = 4, type = 3 },
		is_undead11 = { ability = 'is_undead_buff_plus_plus', condition = 6, type = 3 },
		is_orc = { ability = 'is_orc_buff', condition = 2, type = 1 },
		is_orc1 = { ability = 'is_orc_buff_plus', condition = 4, type = 1 },
		is_orc11 = { ability = 'is_orc_buff_plus_plus', condition = 6, type = 1 },
		is_naga = { ability = 'is_naga_buff', condition = 2, type = 2 },
		is_naga1 = { ability = 'is_naga_buff_plus', condition = 4, type = 2 },
		is_goblin = { ability = 'is_goblin_buff', condition = 3, type = 4 },
		is_goblin1 = { ability = 'is_goblin_buff', condition = 6, type = 1 },
		is_element = { ability = 'is_element_buff', condition = 2, type = 1 },
		is_element1 = { ability = 'is_element_buff', condition = 4, type = 2 },
		is_demon = { ability = 'is_demon_buff', condition = 0, type = 1 },
		is_dwarf = { ability = 'is_dwarf_buff', condition = 1, type = 1 },
		is_ogre = { ability = 'is_ogre_buff', condition = 1, type = 1 },
		is_dragon = {condition = 3 , type = 1},
		is_druid = {condition = 2, type = 1 },
	}

	GameRules:GetGameModeEntity().sm_hero_list = {
		h001 = "models/props_gameplay/donkey.vmdl",
		h002 = "models/props_gameplay/donkey_dire.vmdl",
		--普通信使 beginner
		h101 = "models/courier/skippy_parrot/skippy_parrot.vmdl",
		h102 = "models/courier/smeevil_mammoth/smeevil_mammoth.vmdl",
		h103 = "models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
		h104 = "models/items/courier/axolotl/axolotl.vmdl",
		h105 = "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl",
		h106 = "models/items/courier/coral_furryfish/coral_furryfish.vmdl",
		h107 = "models/items/courier/corsair_ship/corsair_ship.vmdl",
		h108 = "models/items/courier/duskie/duskie.vmdl",
		h109 = "models/items/courier/itsy/itsy.vmdl",
		h110 = "models/items/courier/jumo/jumo.vmdl",
		h111 = "models/items/courier/mighty_chicken/mighty_chicken.vmdl",
		h112 = "models/items/courier/nexon_turtle_05_green/nexon_turtle_05_green.vmdl",
		h113 = "models/items/courier/pumpkin_courier/pumpkin_courier.vmdl",
		h114 = "models/items/courier/pw_ostrich/pw_ostrich.vmdl",
		h115 = "models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl",
		h116 = "models/items/courier/shagbark/shagbark.vmdl",
		h117 = "models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.vmdl",
		h118 = "models/items/courier/snail/courier_snail.vmdl",
		h119 = "models/items/courier/teron/teron.vmdl",
		h120 = "models/items/courier/xianhe_stork/xianhe_stork.vmdl",

		h121 = "models/items/courier/starladder_grillhound/starladder_grillhound.vmdl",
		h122 = "models/items/courier/pw_zombie/pw_zombie.vmdl",
		h123 = "models/items/courier/raiq/raiq.vmdl",
		h124 = "models/courier/frog/frog.vmdl",
		h125 = "models/courier/godhorse/godhorse.vmdl",
		h126 = "models/courier/imp/imp.vmdl",
		h127 = "models/courier/mighty_boar/mighty_boar.vmdl",
		h128 = "models/items/courier/onibi_lvl_03/onibi_lvl_03.vmdl",
		h129 = "models/items/courier/echo_wisp/echo_wisp.vmdl",  --蠕行水母

		h130 = "models/courier/sw_donkey/sw_donkey.vmdl", --驴法师new
		h131 = "models/items/courier/gnomepig/gnomepig.vmdl", --丰臀公主new
		h132 = "models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl",--焚牙树精new
		h133 = "models/courier/mechjaw/mechjaw.vmdl",--机械咬人箱new
		h134 = "models/items/courier/mole_messenger/mole_messenger.vmdl",--1级矿车老鼠
		h135 = "models/items/courier/jumo_dire/jumo_dire.vmdl",

		--小英雄信使 ameteur
		h201 = "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl",
		h202 = "models/courier/huntling/huntling.vmdl",
		h203 = "models/courier/minipudge/minipudge.vmdl",
		h204 = "models/courier/seekling/seekling.vmdl",
		h205 = "models/items/courier/baekho/baekho.vmdl",
		h206 = "models/items/courier/basim/basim.vmdl",
		h207 = "models/items/courier/devourling/devourling.vmdl",
		h208 = "models/items/courier/faceless_rex/faceless_rex.vmdl",
		h209 = "models/items/courier/tinkbot/tinkbot.vmdl",
		h210 = "models/items/courier/lilnova/lilnova.vmdl",

		h211 = "models/items/courier/amphibian_kid/amphibian_kid.vmdl",
		h212 = "models/courier/venoling/venoling.vmdl",
		h213 = "models/courier/juggernaut_dog/juggernaut_dog.vmdl",
		h214 = "models/courier/otter_dragon/otter_dragon.vmdl",
		h215 = "models/items/courier/boooofus_courier/boooofus_courier.vmdl",
		h216 = "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl",
		h217 = "models/courier/yak/yak.vmdl",
		h218 = "models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl",
		h219 = "models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",
		h220 = "models/items/courier/waldi_the_faithful/waldi_the_faithful.vmdl",
		h221 = "models/items/courier/bajie_pig/bajie_pig.vmdl",
		h222 = "models/items/courier/courier_faun/courier_faun.vmdl",
		h223 = "models/items/courier/livery_llama_courier/livery_llama_courier.vmdl",
		h224 = "models/items/courier/onibi_lvl_10/onibi_lvl_10.vmdl",
		h225 = "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl", --胆小南瓜人
		h226 = "models/items/courier/hermit_crab/hermit_crab.vmdl", --螃蟹1
		h227 = "models/items/courier/hermit_crab/hermit_crab_boot.vmdl", --螃蟹2
		h228 = "models/items/courier/hermit_crab/hermit_crab_shield.vmdl", --螃蟹3

		h229 = "models/courier/donkey_unicorn/donkey_unicorn.vmdl", --竭智法师new
		h230 = "models/items/courier/white_the_crystal_courier/white_the_crystal_courier.vmdl", --蓝心白隼new
		h231 = "models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl",--莲花人new
		h232 = "models/courier/beetlejaws/mesh/beetlejaws.vmdl",--甲虫咬人箱new
		h233 = "models/courier/smeevil_bird/smeevil_bird.vmdl",
		h234 = "models/items/courier/mole_messenger/mole_messenger_lvl4.vmdl",--蜡烛头矿车老鼠
		h235 = "models/items/courier/chocobo/chocobo.vmdl", --迅捷陆行鸟
		h236 = "models/items/courier/flightless_dod/flightless_dod.vmdl", --嘟嘟鸟
		h237 = "models/items/courier/frostivus2018_courier_serac_the_seal/frostivus2018_courier_serac_the_seal.vmdl",
		h238 = "models/items/courier/pangolier_squire/pangolier_squire.vmdl",

		--珍藏信使 pro
		h301 = "models/items/courier/bookwyrm/bookwyrm.vmdl",
		h302 = "models/items/courier/captain_bamboo/captain_bamboo.vmdl",
		h303 = "models/items/courier/kanyu_shark/kanyu_shark.vmdl",
		h304 = "models/items/courier/tory_the_sky_guardian/tory_the_sky_guardian.vmdl",
		h305 = "models/items/courier/shroomy/shroomy.vmdl",
		h306 = "models/items/courier/courier_janjou/courier_janjou.vmdl",
		h307 = "models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
		h308 = "models/courier/drodo/drodo.vmdl",
		h309 = "models/courier/mech_donkey/mech_donkey.vmdl",

		h310 = "models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
		h311 = "models/courier/octopus/octopus.vmdl",
		h312 = "models/items/courier/scribbinsthescarab/scribbinsthescarab.vmdl",
		h313 = "models/courier/defense3_sheep/defense3_sheep.vmdl",
		h314 = "models/items/courier/snapjaw/snapjaw.vmdl",
		h315 = "models/items/courier/g1_courier/g1_courier.vmdl",
		h316 = "models/courier/donkey_trio/mesh/donkey_trio.vmdl",
		h317 = "models/items/courier/boris_baumhauer/boris_baumhauer.vmdl",
		h318 = "models/courier/baby_rosh/babyroshan.vmdl",
		h319 = "models/items/courier/bearzky/bearzky.vmdl",
		h320 = "models/items/courier/defense4_radiant/defense4_radiant.vmdl",
		h321 = "models/items/courier/defense4_dire/defense4_dire.vmdl",
		h322 = "models/items/courier/onibi_lvl_20/onibi_lvl_20.vmdl",
		h323 = "models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl", --招财猫
		h324 = "models/items/courier/hermit_crab/hermit_crab_necro.vmdl", --螃蟹4
		h325 = "models/items/courier/hermit_crab/hermit_crab_travelboot.vmdl", --螃蟹5
		h326 = "models/items/courier/hermit_crab/hermit_crab_lotus.vmdl", --螃蟹6
		h327 = "models/courier/donkey_ti7/donkey_ti7.vmdl",

		h328 = "models/items/courier/shibe_dog_cat/shibe_dog_cat.vmdl", --天猫地狗new
		h329 = "models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl",--万圣树群new
		h330 = "models/courier/flopjaw/flopjaw.vmdl",--大嘴咬人箱new
		h331 = "models/courier/lockjaw/lockjaw.vmdl",--咬人箱洛克new
		h332 = "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",--布狗new
		h333 = "models/courier/turtle_rider/turtle_rider.vmdl",
		h334 = "models/courier/smeevil_crab/smeevil_crab.vmdl",
		h335 = "models/items/courier/mole_messenger/mole_messenger_lvl6.vmdl",--绿钻头矿车老鼠
		h336 = "models/items/courier/amaterasu/amaterasu.vmdl", --天照大神

		h399 = "models/courier/baby_rosh/babyroshan_winter18.vmdl",--姜饼肉山

		--战队信使 master
		h401 = "models/courier/navi_courier/navi_courier.vmdl",
		h402 = "models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		h403 = "models/items/courier/ig_dragon/ig_dragon.vmdl",
		h404 = "models/items/courier/lgd_golden_skipper/lgd_golden_skipper.vmdl",
		h405 = "models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl",
		h406 = "models/items/courier/virtus_werebear_t3/virtus_werebear_t3.vmdl",
		h407 = "models/items/courier/throe/throe.vmdl",

		h408 = "models/items/courier/vaal_the_animated_constructradiant/vaal_the_animated_constructradiant.vmdl",
		h409 = "models/items/courier/vaal_the_animated_constructdire/vaal_the_animated_constructdire.vmdl",
		h410 = "models/items/courier/carty/carty.vmdl",
		h411 = "models/items/courier/carty_dire/carty_dire.vmdl",
		h412 = "models/items/courier/dc_angel/dc_angel.vmdl",
		h413 = "models/items/courier/dc_demon/dc_demon.vmdl",
		h414 = "models/items/courier/vigilante_fox_green/vigilante_fox_green.vmdl",
		h415 = "models/items/courier/bts_chirpy/bts_chirpy.vmdl",
		h416 = "models/items/courier/krobeling/krobeling.vmdl",
		h417 = "models/items/courier/jin_yin_black_fox/jin_yin_black_fox.vmdl",
		h418 = "models/items/courier/jin_yin_white_fox/jin_yin_white_fox.vmdl",
		h419 = "models/items/courier/fei_lian_blue/fei_lian_blue.vmdl",
		h420 = "models/items/courier/gama_brothers/gama_brothers.vmdl",
		h421 = "models/items/courier/onibi_lvl_21/onibi_lvl_21.vmdl",
		h422 = "models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes.vmdl", --小飞侠
		h423 = "models/items/courier/hermit_crab/hermit_crab_octarine.vmdl", --螃蟹7
		h424 = "models/items/courier/hermit_crab/hermit_crab_skady.vmdl", --螃蟹8
		h425 = "models/items/courier/hermit_crab/hermit_crab_aegis.vmdl", --螃蟹9

		h426 = "models/items/furion/treant_flower_1.vmdl",--绽放树精new
		h427 = "models/courier/smeevil_magic_carpet/smeevil_magic_carpet.vmdl",
		h428 = "models/items/courier/mole_messenger/mole_messenger_lvl7.vmdl",--绿钻头金矿车老鼠

		h499 = "models/items/courier/krobeling_gold/krobeling_gold_flying.vmdl",--金dp
		h429 = "models/items/courier/nilbog/nilbog.vmdl",--贪小疯魔

		h430 = "models/courier/frull/frull_courier.vmdl", --灵犀弗拉尔
		h431 = "models/items/courier/sltv_10_courier/sltv_10_courier.vmdl", --黄油小生
		h432 = "models/items/courier/nian_courier/nian_courier.vmdl", --年兽宝宝

		h444 = "models/props_gameplay/donkey.vmdl", 
	}
	GameRules:GetGameModeEntity().sm_hero_size = {
		h001 = 1,
		h002 = 1,
		--普通信使 beginner
		h101 = 1.1,
		h102 = 1.1,
		h103 = 1.1,
		h104 = 1,
		h105 = 1,
		h106 = 1,
		h107 = 1.2,
		h108 = 1,
		h109 = 1.1,
		h110 = 1.1,
		h111 = 1.1,
		h112 = 1.2,
		h113 = 1,
		h114 = 1.2,
		h115 = 1.2,
		h116 = 1,
		h117 = 1.3,
		h118 = 1.1,
		h119 = 1.3,
		h120 = 1.3,

		h121 = 1.1,
		h122 = 1.1,
		h123 = 1.2,
		h124 = 1,
		h125 = 1,
		h126 = 1,
		h127 = 1,
		h128 = 1.1,
		h129 = 1.2,  --蠕行水母

		h130 = 1, --驴法师new
		h131 = 1, --丰臀公主new
		h132 = 0.7,--焚牙树精new
		h133 = 1.1,--机械咬人箱new
		h134 = 1.1,--1级矿车老鼠
		h135 = 1.1,

		--小英雄信使 ameteur
		h201 = 1.2,
		h202 = 1.2,
		h203 = 1.2,
		h204 = 1.2,
		h205 = 1.2,
		h206 = 1.2,
		h207 = 1.2,
		h208 = 1.2,
		h209 = 1.2,
		h210 = 1.25,

		h211 = 1.2,
		h212 = 1.1,
		h213 = 1.1,
		h214 = 1.25,
		h215 = 1.2,
		h216 = 1.25,
		h217 = 1.2,
		h218 = 1.1,
		h219 = 1.2,
		h220 = 1.25,
		h221 = 1.25,
		h222 = 1.3,
		h223 = 1.15,
		h224 = 1.25,
		h225 = 1.3, --胆小南瓜人
		h226 = 1.3, --螃蟹1
		h227 = 1.3, --螃蟹2
		h228 = 1.25, --螃蟹3

		h229 = 1.2, --竭智法师new
		h230 = 1.3, --蓝心白隼new
		h231 = 0.8,--莲花人new
		h232 = 1.2,--甲虫咬人箱new
		h233 = 1.2,
		h234 = 1.2,--蜡烛头矿车老鼠
		h235 = 1.2, --迅捷陆行鸟
		h236 = 1.2, --嘟嘟鸟
		h237 = 1.2,
		h238 = 0.8,

		--珍藏信使 pro
		h301 = 1.3,
		h302 = 1.3,
		h303 = 1.3,
		h304 = 1.35,
		h305 = 1.3,
		h306 = 1.3,
		h307 = 1.3,
		h308 = 1.3,
		h309 = 1.2,

		h310 = 1.2,
		h311 = 1.25,
		h312 = 1.3,
		h313 = 1.3,
		h314 = 1.3,
		h315 = 1.25,
		h316 = 1.3,
		h317 = 1.4,
		h318 = 1.3,
		h319 = 1.3,
		h320 = 1.3,
		h321 = 1.3,
		h322 = 1.3,
		h323 = 1.1, --招财猫
		h324 = 1.3, --螃蟹4
		h325 = 1.25, --螃蟹5
		h326 = 1.25, --螃蟹6
		h327 = 1.25,

		h328 = 1.3, --天猫地狗new
		h329 = 0.9,--万圣树群new
		h330 = 1.3,--大嘴咬人箱new
		h331 = 1.25,--咬人箱洛克new
		h332 = 1.3,--布狗new
		h333 = 1.3,
		h334 = 1.3,
		h335 = 1.1,--绿钻头矿车老鼠
		h336 = 1.15, --天照大神

		h399 = 1.2,--姜饼肉山

		--战队信使 master
		h401 = 1.4,
		h402 = 1.4,
		h403 = 1.4,
		h404 = 1.55,
		h405 = 1.4,
		h406 = 1.4,
		h407 = 1.3,

		h408 = 1.35,
		h409 = 1.35,
		h410 = 1.3,
		h411 = 1.3,
		h412 = 1.3,
		h413 = 1.3,
		h414 = 1.4,
		h415 = 1.35,
		h416 = 1.4,
		h417 = 1.4,
		h418 = 1.4,
		h419 = 1.4,
		h420 = 1.2,
		h421 = 1.35,
		h422 = 1.4, --小飞侠
		h423 = 1.3, --螃蟹7
		h424 = 1.3, --螃蟹8
		h425 = 1.3, --螃蟹9

		h426 = 1.1,--绽放树精new
		h427 = 1.55,
		h428 = 1.2,--绿钻头金矿车老鼠

		h499 = 1.5,--金dp
		h429 = 1.3,--贪小疯魔

		h430 = 1.3, --灵犀弗拉尔
		h431 = 1.2, --黄油小生
		h432 = 1.3, --年兽宝宝

		h444 = 1, 
	}
	GameRules:GetGameModeEntity().combined_items = {
		[1] = 'item_fengkuangmianju',
		[2] = 'item_shengjian',
		[3] = 'item_qiangxi',
		[4] = 'item_longxin',
		[5] = 'item_renjia',
		[6] = 'item_xianfengdun',
		[7] = 'item_shuijingjian',
		[8] = 'item_dapao',
		[9] = 'item_anmie',
		[10] = 'item_xuanwo',
		[11] = 'item_dadianchui',
		[12] = 'item_jingubang',
		[13] = 'item_tiaozhantoujin',
		[14] = 'item_yinyuezhijing',

		[15] = 'item_jianrenqiu',
		[16] = 'item_shuaxinqiu',
		[17] = 'item_huiguang',
	}
end
function InitHeros()
	--拼接要向服务器发送的steamid数据
	for pid,sid in pairs(GameRules:GetGameModeEntity().playerid2steamid) do
		GameRules:GetGameModeEntity().upload_detail_stat[sid] = {}
		if GameRules:GetGameModeEntity().steamidlist == '' then
			GameRules:GetGameModeEntity().steamidlist = sid
			GameRules:GetGameModeEntity().steamidlist_heroindex = sid..'_'..GameRules:GetGameModeEntity().playerid2hero[pid]:entindex()
		else
			GameRules:GetGameModeEntity().steamidlist = GameRules:GetGameModeEntity().steamidlist..','..sid
			GameRules:GetGameModeEntity().steamidlist_heroindex = GameRules:GetGameModeEntity().steamidlist_heroindex..','..sid..'_'..GameRules:GetGameModeEntity().playerid2hero[pid]:entindex()
		end
	end
	if string.find(GameRules:GetGameModeEntity().steamidlist,'76561198101849234') or string.find(GameRules:GetGameModeEntity().steamidlist,"76561198090931971") or string.find(GameRules:GetGameModeEntity().steamidlist,"76561198132023205") or string.find(GameRules:GetGameModeEntity().steamidlist,"76561198079679584") then
		GameRules:GetGameModeEntity().myself = true
	end
	--防控制台作弊
	if GameRules:GetGameModeEntity().myself ~= true then
		Timers:CreateTimer(1,function()
			if GameRules:IsCheatMode() == true then
				prt('CHEAT MODE! BYEBYE')
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)				
				return
			end
			return 5
		end)
	end

	GameRules:GetGameModeEntity().cloudlineup = {}
	if PlayerResource:GetPlayerCount() == 1 then
		--单人获取云对战列表
		local url = "http://autochess.ppbizon.com/lineup/get?hehe="..RandomInt(1,10000)
		SendHTTP(url.."&from=InitHeros", function(t)
			prt('LOAD CLOUD LINEUP OK!')
			GameRules:GetGameModeEntity().cloudlineup = t.data
		end)
	end
	--从服务器获取玩家信息
	local url = "http://autochess.ppbizon.com/game/new/@"..GameRules:GetGameModeEntity().steamidlist_heroindex.."?hehe="..RandomInt(1,10000).."&key="..GetDedicatedServerKey('dac')
	SendHTTP(url.."&from=InitHeros", function(t)
		if t.err == 0 then
			prt('CONNECT SERVER OK!')
			for steam_id,user_info in pairs(t.user_info) do
				local hero_index = user_info.hero_index
				local hero = EntIndexToHScript(hero_index)
				local player_id = hero:GetPlayerID()
				if user_info.mmr_level < 19 then
					hero.notbishop = true
				end
				if user_info['ban'] ~= nil then
					prt('BANNED USER: '..GameRules:GetGameModeEntity().steamid2name[steam_id])
					prt('对不起，有玩家被禁止了游戏资格，游戏无法开始。')
					Timers:CreateTimer(5,function()
						GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					end)
					return
				end
				if PlayerResource:GetPlayerCount() == 1 and user_info.vip_tester == true then
					prt('WELCOME VIP TESTER.')
					GameRules:GetGameModeEntity().myself = true
				end
				user_info['player_id'] = player_id
				hero.steam_id = steam_id
				if GameRules:GetGameModeEntity().steamid2name[steam_id] ~= nil then
					hero.player_name = GameRules:GetGameModeEntity().steamid2name[steam_id]
				end

				local onduty_hero_long = user_info.onduty_hero
				local onduty_hero = string.split(onduty_hero_long,'_')[1]
				local onduty_hero_effect = string.split(onduty_hero_long,'_')[2] or ''

				user_info['onduty_hero'] = onduty_hero
				user_info['onduty_hero_effect'] = onduty_hero_effect

				local init_hp = 100
				GameRules:GetGameModeEntity().stat_info[steam_id] = {
					hp = init_hp,
					player_id = player_id,
					duration = 0,
					zhugong = onduty_hero,
					zhugong_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero],
					zhugong_effect = onduty_hero_effect,
					round = 0,
					win_round = 0,
					lose_round = 0,
					draw_round = 0,
					kills = 0,
					deaths = 0,
					mmr_level = user_info.mmr_level,
					chess_lineup = '',
					candy = 0,
				}

				local onduty_hero_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero]

				hero:SetOriginalModel(onduty_hero_model)
				hero:SetModel(onduty_hero_model)
				hero.init_model_scale = GameRules:GetGameModeEntity().sm_hero_size[onduty_hero] or 1
				hero:SetModelScale(hero.init_model_scale)
				hero.ori_model = onduty_hero_model

				hero.steam_id = steam_id

				hero:MoveToPosition(hero:GetAbsOrigin())
				AddAbilityAndSetLevel(hero,'pick_chess')
				AddAbilityAndSetLevel(hero,'recall_chess')
			    AddAbilityAndSetLevel(hero,'remove_chess')
			    AddAbilityAndSetLevel(hero,'summon_hero')
			    AddAbilityAndSetLevel(hero,'exp_book')

			    if onduty_hero_effect ~= 'e000' then
			    	AddAbilityAndSetLevel(hero,onduty_hero_effect)
			    	hero.effect = onduty_hero_effect
			    end

				AddAbilityAndSetLevel(hero,'jiaoxie_wudi_hero')
				AddAbilityAndSetLevel(hero,'wudi')
			    AddAbilityAndSetLevel(hero,'no_hp_add')
			end
			GameRules:GetGameModeEntity().user_info = t.user_info
			CustomNetTables:SetTableValue( "dac_table", "player_info", { info = t.user_info, hehe = RandomInt(1,1000)})
			
			if t.chess_pool ~= nil  then
				if t.chess_pool.pool_size ~= nil then
					GameRules:GetGameModeEntity().CHESS_POOL_SIZE = t.chess_pool.pool_size
				end
				if t.chess_pool.chess_init_1 ~= nil then
					GameRules:GetGameModeEntity().CHESS_INIT_COUNT[1] = t.chess_pool.chess_init_1
				end
				if t.chess_pool.chess_init_2 ~= nil then
					GameRules:GetGameModeEntity().CHESS_INIT_COUNT[2] = t.chess_pool.chess_init_2
				end
				if t.chess_pool.chess_init_3 ~= nil then
					GameRules:GetGameModeEntity().CHESS_INIT_COUNT[3] = t.chess_pool.chess_init_3
				end
				if t.chess_pool.chess_init_4 ~= nil then
					GameRules:GetGameModeEntity().CHESS_INIT_COUNT[4] = t.chess_pool.chess_init_4
				end
				if t.chess_pool.chess_init_5 ~= nil then
					GameRules:GetGameModeEntity().CHESS_INIT_COUNT[5] = t.chess_pool.chess_init_5
				end
			end

			StartGame()
		elseif t.err == 1100 then
			prt('对不起，有玩家没有获得内测资格，游戏无法开始。')
			Timers:CreateTimer(30,function()
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end)
			return
		else
			--连接服务器失败了，用默认信使玩
			prt('CONNECT SERVER ERROR : '..t.err)

			local user_info_table = {}
			is_game_can_start = true
			local steamid_table = string.split(GameRules:GetGameModeEntity().steamidlist_heroindex,',')

			--默认玩家数据
			for _,v in pairs(steamid_table) do 
				local steamid = string.split(v,'_')[1]
				local hero_index = string.split(v,'_')[2]
				user_info_table[steamid] = {
					steamid = steamid,
					candy = 0,
					mmr = 0,
					match = 0,
					zhugong = {
						[1] = "h001_e000"
					},
					onduty_hero = "h001_e000",
					mmr_level = 0,
					hero_index = tonumber(hero_index),
				}
			end

			for steam_id,user_info in pairs(user_info_table) do
				local hero_index = user_info.hero_index
				local hero = EntIndexToHScript(hero_index)
				local player_id = hero:GetPlayerID()
				user_info['player_id'] = player_id
				hero.steam_id = steam_id
				if GameRules:GetGameModeEntity().steamid2name[steam_id] ~= nil then
					hero.player_name = GameRules:GetGameModeEntity().steamid2name[steam_id]
				end

				local onduty_hero_long = user_info.onduty_hero
				local onduty_hero = string.split(onduty_hero_long,'_')[1]
				local onduty_hero_effect = string.split(onduty_hero_long,'_')[2] or ''

				user_info['onduty_hero'] = onduty_hero
				user_info['onduty_hero_effect'] = onduty_hero_effect

				local init_hp = 100
				GameRules:GetGameModeEntity().stat_info[steam_id] = {
					hp = init_hp,
					player_id = player_id,
					duration = 0,
					zhugong = onduty_hero,
					zhugong_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero],
					zhugong_effect = onduty_hero_effect,
					round = 0,
					win_round = 0,
					lose_round = 0,
					draw_round = 0,
					kills = 0,
					deaths = 0,
					mmr_level = user_info.mmr_level,
					chess_lineup = '',
					candy = 0,
				}

				local onduty_hero_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero]

				hero:SetOriginalModel(onduty_hero_model)
				hero:SetModel(onduty_hero_model)
				hero.init_model_scale = GameRules:GetGameModeEntity().sm_hero_size[onduty_hero] or 1
				hero:SetModelScale(hero.init_model_scale)
				hero.ori_model = onduty_hero_model

				hero.steam_id = steam_id

				hero:MoveToPosition(hero:GetAbsOrigin())
				AddAbilityAndSetLevel(hero,'pick_chess')
				AddAbilityAndSetLevel(hero,'recall_chess')
			    AddAbilityAndSetLevel(hero,'remove_chess')
			    AddAbilityAndSetLevel(hero,'summon_hero')
			    AddAbilityAndSetLevel(hero,'exp_book')

			    if onduty_hero_effect ~= 'e000' then
			    	AddAbilityAndSetLevel(hero,onduty_hero_effect)
			    end

				AddAbilityAndSetLevel(hero,'jiaoxie_wudi_hero')
				AddAbilityAndSetLevel(hero,'wudi')
			    AddAbilityAndSetLevel(hero,'no_hp_add')
			end
			GameRules:GetGameModeEntity().user_info = user_info_table
			CustomNetTables:SetTableValue( "dac_table", "player_info", { info = user_info_table, hehe = RandomInt(1,1000)})
			StartGame()
		end
	end, function()
		--连接服务器失败了，用默认信使玩
		prt('CONNECT SERVER ERROR : '..t.err)

		local user_info_table = {}
		is_game_can_start = true
		local steamid_table = string.split(GameRules:GetGameModeEntity().steamidlist_heroindex,',')

		--默认玩家数据
		for _,v in pairs(steamid_table) do 
			local steamid = string.split(v,'_')[1]
			local hero_index = string.split(v,'_')[2]
			user_info_table[steamid] = {
				steamid = steamid,
				candy = 0,
				mmr = 0,
				match = 0,
				zhugong = {
					[1] = "h001_e000"
				},
				onduty_hero = "h001_e000",
				mmr_level = 0,
				hero_index = tonumber(hero_index),
			}
		end

		for steam_id,user_info in pairs(user_info_table) do
			local hero_index = user_info.hero_index
			local hero = EntIndexToHScript(hero_index)
			local player_id = hero:GetPlayerID()
			user_info['player_id'] = player_id
			hero.steam_id = steam_id
			if GameRules:GetGameModeEntity().steamid2name[steam_id] ~= nil then
				hero.player_name = GameRules:GetGameModeEntity().steamid2name[steam_id]
			end

			local onduty_hero_long = user_info.onduty_hero
			local onduty_hero = string.split(onduty_hero_long,'_')[1]
			local onduty_hero_effect = string.split(onduty_hero_long,'_')[2] or ''

			user_info['onduty_hero'] = onduty_hero
			user_info['onduty_hero_effect'] = onduty_hero_effect

			local init_hp = 100
			GameRules:GetGameModeEntity().stat_info[steam_id] = {
				hp = init_hp,
				player_id = player_id,
				duration = 0,
				zhugong = onduty_hero,
				zhugong_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero],
				zhugong_effect = onduty_hero_effect,
				round = 0,
				win_round = 0,
				lose_round = 0,
				draw_round = 0,
				kills = 0,
				deaths = 0,
				mmr_level = user_info.mmr_level,
				chess_lineup = '',
				candy = 0,
			}

			local onduty_hero_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero]

			hero:SetOriginalModel(onduty_hero_model)
			hero:SetModel(onduty_hero_model)
			hero.init_model_scale = GameRules:GetGameModeEntity().sm_hero_size[onduty_hero] or 1
			hero:SetModelScale(hero.init_model_scale)
			hero.ori_model = onduty_hero_model

			hero.steam_id = steam_id

			hero:MoveToPosition(hero:GetAbsOrigin())
			AddAbilityAndSetLevel(hero,'pick_chess')
			AddAbilityAndSetLevel(hero,'recall_chess')
		    AddAbilityAndSetLevel(hero,'remove_chess')
		    AddAbilityAndSetLevel(hero,'summon_hero')
		    AddAbilityAndSetLevel(hero,'exp_book')

		    if onduty_hero_effect ~= 'e000' then
		    	AddAbilityAndSetLevel(hero,onduty_hero_effect)
		    end

			AddAbilityAndSetLevel(hero,'jiaoxie_wudi_hero')
			AddAbilityAndSetLevel(hero,'wudi')
		    AddAbilityAndSetLevel(hero,'no_hp_add')
		end
		GameRules:GetGameModeEntity().user_info = user_info_table
		CustomNetTables:SetTableValue( "dac_table", "player_info", { info = user_info_table, hehe = RandomInt(1,1000)})
		StartGame()
	end)
end
--2、自动选英雄后给主公加技能
function DAC:OnPlayerPickHero(keys)
	if IsServer() == true then
		local player = EntIndexToHScript(keys.player)
	    local hero = EntIndexToHScript(keys.heroindex)
	    local children = hero:GetChildren()
	    for k,child in pairs(children) do
	       if child:GetClassname() == "dota_item_wearable" then
	           child:RemoveSelf()
	       end
	    end
	    for slot=0,8 do
			if hero:GetItemInSlot(slot)~= nil then
				hero:RemoveItem(hero:GetItemInSlot(slot))
			end
		end
	    hero:SetHullRadius(1)
	    hero:SetAbilityPoints(0)
	    for i=1,16 do
	    	hero:RemoveAbility("empty"..i)
	    end
		hero:SetMana(0)
		-- AddAbilityAndSetLevel(hero,'hero_level_1',1)

		--test particle
		-- PlayParticleOnUnitUntilDeath({
		-- 	caster = hero,
		-- 	p = 'effect/dizuo/1.vpcf',
		-- })

		hero.team = hero:GetTeam()
		hero.team_id = hero:GetTeam()

		--设置玩家颜色
		-- PlayerResource:SetCustomPlayerColor(hero:GetPlayerID(),GameRules:GetGameModeEntity().team_color[hero:GetTeam()].r,GameRules:GetGameModeEntity().team_color[hero:GetTeam()].g,GameRules:GetGameModeEntity().team_color[hero:GetTeam()].b)


		GameRules:GetGameModeEntity().team2playerid[hero:GetTeam()] = player:GetPlayerID()
		GameRules:GetGameModeEntity().counterpart[hero:GetTeam()] = 0
		GameRules:GetGameModeEntity().playerid2team[player:GetPlayerID()] = hero:GetTeam()

		--将所有玩家的英雄存到一个数组
		local heroindex = keys.heroindex
	    GameRules:GetGameModeEntity().hero[heroindex] = EntIndexToHScript(heroindex)
	    GameRules:GetGameModeEntity().playerid2hero[player:GetPlayerID()] = EntIndexToHScript(heroindex)
	    GameRules:GetGameModeEntity().teamid2hero[hero:GetTeam()] = EntIndexToHScript(heroindex)
	    local playercount = 0
	    for i,vi in pairs(GameRules:GetGameModeEntity().hero) do
	    	playercount = playercount +1
	    end

	    print("PlayerCount: "..playercount.."/"..PlayerResource:GetPlayerCount())

	    if playercount == PlayerResource:GetPlayerCount() then
	    	Timers:CreateTimer(0.1,function()
	    		InitHeros()
	    	end)
	    end 
	end
end
--英雄升级
function DAC:OnPlayerGainedLevel(keys)
	local i = 0
	for i = 6, 13 do
		GameRules:GetGameModeEntity().population_max[i] = GetMaxChessCount(i)

		local hero = TeamId2Hero(i)

		if hero ~= nil then 
			hero:SetAbilityPoints(0)
			local level = hero:GetLevel()
			for j=1,10 do
				if hero:FindAbilityByName('hero_level_'..j) ~= nil then
					hero:RemoveAbility('hero_level_'..j)
					hero:RemoveModifierByName('modifier_hero_level'..j)
				end
			end

			AddAbilityAndSetLevel(hero,'hero_level_'..level,level)
		end

		--同步ui人口
		CustomGameEventManager:Send_ServerToTeam(i,"population",{
			max_count = GameRules:GetGameModeEntity().population_max[i],
			count = GameRules:GetGameModeEntity().population[i],
		})

	end
end

--每次连接后保存userid到player的映射关系
function DAC:OnPlayerConnectFull(keys)
	GameRules:GetGameModeEntity().playerid2steamid[keys.PlayerID] = tostring(PlayerResource:GetSteamID(keys.PlayerID))
	GameRules:GetGameModeEntity().steamid2playerid[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = keys.PlayerID
	GameRules:GetGameModeEntity().steamid2name[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = tostring(PlayerResource:GetPlayerName(keys.PlayerID))
	GameRules:GetGameModeEntity().userid2player[keys.userid] = keys.index+1

	GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = true
	if GameRules:GetGameModeEntity().isConnected[keys.index + 1] == true then
		local hero = PlayerId2Hero(keys.PlayerID)
		--重连
		CustomGameEventManager:Send_ServerToAllClients("player_reconnect",{
			id = keys.PlayerID
		})

		Timers:CreateTimer(RandomFloat(0,0.5),function()
			CustomNetTables:SetTableValue( "dac_table", "player_info", {info = GameRules:GetGameModeEntity().user_info, hehe = RandomInt(1,1000)})
			Timers:CreateTimer(RandomFloat(0,0.5),function()
				GameRules:GetGameModeEntity().stat_info[hero.steam_id]['hp'] = hero:GetHealth()
				CustomNetTables:SetTableValue( "dac_table", "user_panel_ranking", {table = GameRules:GetGameModeEntity().stat_info, hehe = RandomInt(1,1000)})

				--同步ui血量
				CustomGameEventManager:Send_ServerToAllClients("sync_hp",{
					player_id = hero:GetPlayerID(),
					hp = hero:GetHealth(),
					hp_max = hero:GetMaxHealth(),
				})
			end)
		end)
		Timers:CreateTimer(RandomFloat(0,0.5),function()
			GameRules:GetGameModeEntity().population_max[hero:GetTeam()] = hero:GetLevel()
			
			--同步ui人口
			CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(),"population",{
				max_count = GameRules:GetGameModeEntity().population_max[hero:GetTeam()],
				count = GameRules:GetGameModeEntity().population[hero:GetTeam()],
			})
		end)
		Timers:CreateTimer(RandomFloat(0,0.5),function()
			CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(),"show_gold",{
				gold = hero:GetMana(),
				lose_streak = hero.lose_streak or 0,
				win_streak = hero.win_streak or 0,
			})
		end)
		Timers:CreateTimer(RandomFloat(0,0.5),function()
			local cardstr = ''
			for _,card in pairs(hero.curr_chess_table) do
				cardstr = cardstr..card..','
			end
			CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(),"show_draw_card",{
				cards = cardstr,
				curr_money = hero:GetMana(),
			})
		end)

		Timers:CreateTimer(RandomFloat(0,1),function()
			CustomNetTables:SetTableValue( "dac_table", "user_panel_ranking", {table = GameRules:GetGameModeEntity().stat_info, hehe = RandomInt(1,1000)})

			--同步ui血量
			for i=0,PlayerResource:GetPlayerCount()-1 do
				local h = PlayerId2Hero(i)
				if h ~= nil and h:IsNull() == false and h:IsAlive() == true then
					CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(),"sync_hp",{
						player_id = i,
						hp = h:GetHealth(),
						hp_max = h:GetMaxHealth(),
					})
				else
					CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(),"sync_hp",{
						player_id = i,
						hp = 0,
						hp_max = 100,
					})
				end
			end
		end)




		hero.isDisconnected = false
	end
	GameRules:GetGameModeEntity().isConnected[keys.index+1] = true;
end
--断线
function DAC:OnPlayerDisconnect(keys)
	if IsServer() then
		local hero = PlayerId2Hero(keys.PlayerID)
		hero.isDisconnected = true
		GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = false
		CustomNetTables:SetTableValue( "dac_table", "disconnect", 
			{ 
				table = GameRules:GetGameModeEntity().connect_state,
				hehe = RandomInt(1,100000)
			} 
		)
		-- CustomGameEventManager:Send_ServerToAllClients("player_disconnect",{
		-- 	disconnectid = keys.PlayerID
		-- })
	end
end
--暂时不用了
function DAC:OnDeckReiceived(keys)
	if keys.deck == nil then
		keys.deck = GameRules:GetGameModeEntity().steamid2deck2cards[keys.steam_id][keys.deck_id]
	end

	local heroindex_old = tonumber(GameRules:GetGameModeEntity().steamid2heroindex[keys.steam_id])
	local hero = EntIndexToHScript(heroindex_old)

	if hero.is_ready == true then
		return
	end

	local id = hero:GetPlayerID()
	local steam_id = keys.steam_id
	local team_old = hero.team

	keys.hero = GameRules:GetGameModeEntity().HEROS[keys.hero] or keys.hero

	PrecacheUnitByNameAsync( keys.hero, function()

		local hero_new = PlayerResource:ReplaceHeroWith(id,keys.hero,PlayerResource:GetGold(id),0)

		hero_new.steam_id = steam_id
		hero_new.droping = false
		hero_new.drawing = false
		hero_new.team = team_old
		heroindex = hero_new:GetEntityIndex()
		GameRules:GetGameModeEntity().heroindex2steamid[heroindex_old] = nil
		GameRules:GetGameModeEntity().steamid2heroindex[keys.steam_id] = heroindex
		GameRules:GetGameModeEntity().heroindex2steamid[heroindex] = keys.steam_id

		GameRules:GetGameModeEntity().hero[heroindex_old] = nil
		GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

		hero_new.is_ready = true
		
		--填充手牌
		hero_new.deck = {}
		for u,v in pairs(keys.deck) do
			table.insert(hero_new.deck, v)
		end


		if DEFAULT_DECK ~= nil then
			hero_new.deck = DEFAULT_DECK
		end

		--送tp问题
		for slot=0,8 do
			if hero_new:GetItemInSlot(slot)~= nil then
				hero_new:RemoveItem(hero_new:GetItemInSlot(slot))
			end
		end

		if hero_new:GetModelScale() < 0.1 then
			hero_new:SetModelScale(0.9)
		    local children = hero_new:GetChildren()
		    for k,child in pairs(children) do
		       if child:GetClassname() == "dota_item_wearable" then
		           child:RemoveSelf()
		       end
		    end
		end
		hero_new.hand = {}

		--触发战吼？
		if hero_new:GetUnitName() == "npc_dota_hero_alchemist" then
			hero_new:AddAbility("zibao")
			hero_new:FindAbilityByName("zibao"):SetLevel(1)
			Timers:CreateTimer(0.2,function()
				local newOrder = {
			 		UnitIndex = hero_new:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		TargetIndex = nil, 
			 		AbilityIndex = hero_new:FindAbilityByName("zibao"):entindex(), 
			 		Position = nil, 
			 		Queue = 0 
			 	}
				ExecuteOrderFromTable(newOrder)

				Timers:CreateTimer(9.8,function()
					hero_new:RemoveAbility("zibao")
				end)
			end)
		end

		if hero_new:GetUnitName() == "npc_dota_hero_invoker" then
			hero_new:AddAbility("no_duplicate")
			hero_new:FindAbilityByName("no_duplicate"):SetLevel(1)
		end
		hero_new:SetMana(0)

		

		--是否全部ready
		local readyplayercount = 0
	    for i,vi in pairs(GameRules:GetGameModeEntity().hero) do
	    	if vi.is_ready == true then
	    		readyplayercount = readyplayercount +1
	    	end
	    end

	    -- 通知pui游戏开始
	    if readyplayercount == PlayerResource:GetPlayerCount() then
	    	if GameRules:GetGameModeEntity().is_game_started == true then
				return
			end
	    	GameRules:GetGameModeEntity().is_game_started = true
	    	Ready2StartGame()
	    end 

	end, id)
end
--游戏循环1——开始一轮准备回合
function StartAPrepareRound()
	-- StatChess()

	CustomNetTables:SetTableValue( "dac_table", "damage_stat", 
		{ 
			level = GameRules:GetGameModeEntity().level, 
			damage_table = GameRules:GetGameModeEntity().damage_stat , 
			time_this_level = 61 - GameRules:GetGameModeEntity().battle_timer, 
			hehe = RandomInt(1,100000) 
		} 
	)

	--50回合以后，疲劳
	if GameRules:GetGameModeEntity().battle_round > 50 then
		local bite_hp = GameRules:GetGameModeEntity().battle_round - 50
		for _,heroent in pairs (GameRules:GetGameModeEntity().hero) do
			if heroent ~= nil and heroent:IsNull() == false and heroent:IsAlive() == true then
				local after_hp = heroent:GetHealth() - bite_hp
				if after_hp <= 0 then
					after_hp = 0
				end
				play_particle("particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_proj_hit_streaks.vpcf",PATTACH_ABSORIGIN_FOLLOW,heroent,3)
				if after_hp <= 0 then
					--死了
					heroent:ForceKill(false)
					GameRules:GetGameModeEntity().counterpart[heroent:GetTeam()] = -1
					SyncHP(heroent)
					AMHC:CreateNumberEffect(heroent,bite_hp,2,AMHC.MSG_MISS,"red",9)
					ClearHand(heroent:GetTeam())
					return
				end
				heroent:SetHealth(after_hp)
				SyncHP(heroent)
				AMHC:CreateNumberEffect(heroent,bite_hp,2,AMHC.MSG_MISS,"red",9)
				EmitSoundOn("Frostivus.PointScored.Enemy",hero)
			end
		end		
	end
	
	CustomNetTables:SetTableValue( "dac_table", "user_panel_ranking", {table = GameRules:GetGameModeEntity().stat_info, hehe = RandomInt(1,1000)})
	GameRules:SetTimeOfDay(0.8)
	EmitGlobalSound("Loot_Drop_Stinger_Legendary")
	GameRules:GetGameModeEntity().game_status = 1

	GameRules:GetGameModeEntity().prepare_timer = 35
	
	CustomGameEventManager:Send_ServerToAllClients("battle_info",{
		type = "prepare",
		round = GameRules:GetGameModeEntity().battle_round,
	})

	local alldead = true
	for i,v in pairs (GameRules:GetGameModeEntity().counterpart) do
		if v ~= -1 then
			local hhh = TeamId2Hero(i)
			if hhh.hand_entities ~= nil then
				for _,ent in pairs(hhh.hand_entities) do
					if ent ~= nil and ent:IsNull() == false then
						ent:RemoveAbility('outofgame')
						ent:RemoveModifierByName('modifier_outofgame')
					end
				end
			end
			alldead = false
		end
	end
	if alldead == true then
		return
	end
	Timers:CreateTimer(function()
		if GameRules:GetGameModeEntity().prepare_timer <= 10 and GameRules:GetGameModeEntity().prepare_timer > 5 then
			EmitGlobalSound('General.CastFail_AbilityInCooldown')
		end

		if GameRules:GetGameModeEntity().prepare_timer <= 5 then
			if GameRules:GetGameModeEntity().prepare_timer == 5 then
				EmitGlobalSound("GameStart.RadiantAncient")

				if GameRules:GetGameModeEntity().battle_boss[GameRules:GetGameModeEntity().battle_round] ~= nil then
					ShowCombat({
						t = 'round_pve',
						text = GameRules:GetGameModeEntity().battle_round
					})
				else
					ShowCombat({
						t = 'round_pvp',
						text = GameRules:GetGameModeEntity().battle_round
					})
				end
			end

			if GameRules:GetGameModeEntity().prepare_timer == 2 then
				RandomRecallChess()
			end
			
			for i,v in pairs (GameRules:GetGameModeEntity().hero) do
				CancelPickChess(v)
				v:FindAbilityByName('pick_chess'):SetActivated(false)
				v:FindAbilityByName('recall_chess'):SetActivated(false)
			end
		end
		if GameRules:GetGameModeEntity().prepare_timer <= 0 then
			GameRules:GetGameModeEntity().game_status = 2
			-- GameRules:SendCustomMessage('战斗回合',0,0)
			StartABattleRound()
			return
		else
			local center_index = ''..Entities:FindByName(nil,"center0"):entindex()..','..Entities:FindByName(nil,"center1"):entindex()..','..Entities:FindByName(nil,"center2"):entindex()..','..Entities:FindByName(nil,"center3"):entindex()..','..Entities:FindByName(nil,"center4"):entindex()..','..Entities:FindByName(nil,"center5"):entindex()..','..Entities:FindByName(nil,"center6"):entindex()..','..Entities:FindByName(nil,"center7"):entindex()
			--发送当前游戏时间给客户端
			if GameRules:GetGameModeEntity().prepare_timer > 5 then
				CustomGameEventManager:Send_ServerToAllClients("show_time",{
					timer_round = GameRules:GetGameModeEntity().prepare_timer - 5,
					round_status = "prepare",
					total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME),
					center_index = center_index,
				})
			else
				CustomGameEventManager:Send_ServerToAllClients("show_time",{
					timer_round = GameRules:GetGameModeEntity().prepare_timer,
					round_status = "ready",
					total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME),
					center_index = center_index,
				})
			end
			GameRules:GetGameModeEntity().prepare_timer = GameRules:GetGameModeEntity().prepare_timer - 1
			return 1
		end
	end)
	Timers:CreateTimer(0.3,function()
		for i,v in pairs(GameRules:GetGameModeEntity().hero) do
			if GameRules:GetGameModeEntity().battle_round == 1 and v.notbishop == true and GetMapName() == "bishop+" then
				prt('Sorry, this map is for players ranking higher than bishop-1!')
				prt('对不起，此地图仅对主教一段以上玩家开放')
				v:ForceKill(false)
				GameRules:GetGameModeEntity().counterpart[v:GetTeam()] = -1
				SyncHP(v)
			end
			if v == nil or v:IsNull() == true or v:IsAlive() == true then
				RestoreARound(v:GetTeam())
				
				AddPickAndRemoveAbility(v)
				
				
				if v ~= nil then 
					local level = v:GetLevel()
					for j=1,10 do
						if v:FindAbilityByName('hero_level_'..j) ~= nil then
							v:RemoveAbility('hero_level_'..j)
							v:RemoveModifierByName('modifier_hero_level'..j)
						end
					end

					AddAbilityAndSetLevel(v,'hero_level_'..level,level)
				end

				--给蓝
				local mana = GameRules:GetGameModeEntity().battle_round
				if mana> 5 then
					mana = 5
				end

				local lixi = math.floor(v:GetMana()/10)
				if lixi > 5 then
					lixi = 5
				end
				mana = mana + lixi

				local anwei = math.floor(((v.lose_streak or 0)+3)/2 ) - 2
				if anwei < 0 then
					anwei = 0
				end
				if anwei > 3 then
					anwei = 3
				end
				mana = mana + anwei

				local jiangli = math.floor(((v.win_streak or 0)+3)/2 ) - 2
				if jiangli < 0 then
					jiangli = 0
				end
				if jiangli > 3 then
					jiangli = 3
				end
				mana = mana + jiangli
				Timers:CreateTimer(1,function()
					AddMana(v, mana)
					CustomGameEventManager:Send_ServerToTeam(v:GetTeam(),"show_gold",{
						gold = v:GetMana(),
						lose_streak = v.lose_streak or 0,
						win_streak = v.win_streak or 0,
					})
				end)
				Timers:CreateTimer(0.5,function()
					PrepareARound(v:GetTeam())
				end)
				
				--给一点经验
				if GameRules:GetGameModeEntity().battle_round ~= 1 then
					v:AddExperience (1,0,false,false)
				end

				GameRules:GetGameModeEntity().damage_stat[v:GetTeam()] = {}

			end
		end
	end)
end
function AddPickAndRemoveAbility(v)
	Timers:CreateTimer(1.5,function()
		if v:FindAbilityByName('pick_chess') == nil then
			AddAbilityAndSetLevel(v,'pick_chess')
		end
	   	if v:FindAbilityByName('recall_chess') == nil then
	   		AddAbilityAndSetLevel(v,'recall_chess')
	   	end
		if v:FindAbilityByName('remove_chess') == nil then
	    	AddAbilityAndSetLevel(v,'remove_chess')
	    end
		v:FindAbilityByName('pick_chess'):SetActivated(true)
		v:FindAbilityByName('recall_chess'):SetActivated(true)
	end)
	-- v:FindAbilityByName('remove_chess'):SetActivated(true)
end
--游戏循环1.1——清理战斗场地并重新摆上自己的随从
function RestoreARound(teamid)
	ClearARound(teamid)

	Timers:CreateTimer(RandomFloat(0.5,1),function()
		for _,v in pairs(GameRules:GetGameModeEntity().mychess[teamid]) do
			local x = CreateUnitByName(v.chess,XY2Vector(v.x,v.y,teamid),true,nil,nil,teamid)
			MakeTiny(x)
			table.insert(GameRules:GetGameModeEntity().to_be_destory_list[teamid],x)
			x:SetForwardVector(Vector(0,1,0))
			AddAbilityAndSetLevel(x,'root_self')
			AddAbilityAndSetLevel(x,'jiaoxie_wudi')
			x.y_x = ''..v.y..'_'..v.x
			x.y = v.y
			x.x = v.x
			x.team_id = teamid
			local item_table = v.item  
			if table.maxn(item_table) > 0 then
				for p,vp in pairs (item_table) do
					x:AddItemByName(vp)
				end
			end
			GameRules:GetGameModeEntity().mychess[teamid][''..v.y..'_'..v.x]['index'] = x:entindex()
			GameRules:GetGameModeEntity().mychess[teamid][''..v.y..'_'..v.x]['lastitem'] = CopyTable(GameRules:GetGameModeEntity().mychess[teamid][''..v.y..'_'..v.x]['item'])
			GameRules:GetGameModeEntity().mychess[teamid][''..v.y..'_'..v.x]['item'] = {}

			GameRules:GetGameModeEntity().unit[teamid][v.y..'_'..v.x] = 1
			--添加战斗技能
			if GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()] ~= nil then
				local a = GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()]
				if x:FindAbilityByName(a) == nil then
					AddAbilityAndSetLevel(x,a,0)
				end
			end
		end
	end)
	
end
function ClearARound(teamid)
	for _,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
		if v ~= nil and v:IsNull() == false then
			-- SaveItem(teamid,v:entindex())

			-- prt('ClearARound保存玩家'..teamid..' '..v:GetUnitName()..'的物品： ROUND '..GameRules:GetGameModeEntity().battle_round)
			AddAbilityAndSetLevel(v,'no_selectable')
			--需要手动清除防止遗留的buff
			v:RemoveModifierByName('modifier_slark_shadow_dance')

			Timers:CreateTimer(RandomFloat(0.1,0.3),function()
				SaveItem(teamid,v:entindex(),function()
					v:Destroy()
				end)
				
			end)
		end
	end
	GameRules:GetGameModeEntity().to_be_destory_list[teamid] = {}
	GameRules:GetGameModeEntity().unit[teamid] = {}

	local hero = TeamId2Hero(teamid)
	if hero.mirror_chesser ~= nil then
		hero.mirror_chesser:Destroy()
		hero.mirror_chesser = nil
	end
end
function SaveItem(teamid,uindex,cb)
	local thischess = nil
	if uindex == nil then
		return
	end
	local unit = EntIndexToHScript(uindex)
	if unit == nil or unit:IsNull() == true then
		return
	end
	--先清空物品table
	for _,c in pairs (GameRules:GetGameModeEntity().mychess[teamid]) do
		if c.index == uindex then
			c.item = {}
		end
	end
	-- prt('清空完毕：TIME '..math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME))
	--记录装备情况
	for slot=0,8 do
		if unit:GetItemInSlot(slot)~= nil then
			local name = unit:GetItemInSlot(slot):GetAbilityName()
			for i,v in pairs(GameRules:GetGameModeEntity().mychess[teamid]) do
				if v.index == uindex then
					table.insert(v.item,name)
				end
			end
		end
	end

	if cb~=nil then
		cb()
	end
	--跟lastitem比较是否有新物品
	-- local new_item = {}
	-- if thischess ~= nil then
	-- 	if thischess.lastitem == nil then
	-- 		thischess.lastitem = {}
	-- 	end
	-- 	new_item = DiffTable(thischess.item,thischess.lastitem)
	-- 	if table.maxn(new_item) > 0 then
	-- 		for i1,v1 in pairs(new_item) do
	-- 			if FindValueInTable(GameRules:GetGameModeEntity().combined_items,v1) == true then
	-- 				--发弹幕
	-- 				CustomNetTables:SetTableValue( "dac_table", "bullet", {player_id = TeamId2Hero(teamid):GetPlayerID(), target = v1 , hehe = RandomInt(1,100000)})
	-- 			end
	-- 		end
	-- 	end
	-- 	thischess.lastitem = CopyTable(thischess.item)
	-- end
	-- if unit:IsAlive() == true then
	-- 	--活棋子
	-- 	--遍历它身上有的物品，保存到table，重新添加一遍便于合成
	-- 	for slot=0,8 do
	-- 		if unit:GetItemInSlot(slot)~= nil then
	-- 			local name = unit:GetItemInSlot(slot):GetAbilityName()
	-- 			for i,v in pairs(GameRules:GetGameModeEntity().mychess[teamid]) do
	-- 				if v.index == uindex then
	-- 					table.insert(v.item,name)
	-- 					thischess = GameRules:GetGameModeEntity().mychess[teamid][unit.y_x]
	-- 					unit:RemoveItem(unit:GetItemInSlot(slot))
	-- 					unit:AddItemByName(name)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- 	--跟lastitem比较是否有新物品
	-- 	local new_item = {}
	-- 	if thischess ~= nil then
	-- 		if thischess.lastitem == nil then
	-- 			thischess.lastitem = {}
	-- 		end
	-- 		new_item = DiffTable(thischess.item,thischess.lastitem)
	-- 		if table.maxn(new_item) > 0 then
	-- 			for i1,v1 in pairs(new_item) do
	-- 				if FindValueInTable(GameRules:GetGameModeEntity().combined_items,v1) == true then
	-- 					--发弹幕
	-- 					CustomNetTables:SetTableValue( "dac_table", "bullet", {player_id = TeamId2Hero(teamid):GetPlayerID(), target = v1 , hehe = RandomInt(1,100000)})
	-- 				end
	-- 			end
	-- 		end
	-- 		thischess.lastitem = CopyTable(thischess.item)
	-- 	end
	-- else
	-- 	--死棋子
	-- 	--遍历它身上有的物品，保存到table
	-- 	for slot=0,8 do
	-- 		if unit:GetItemInSlot(slot)~= nil then
	-- 			local name = unit:GetItemInSlot(slot):GetAbilityName()
	-- 			for i,v in pairs(GameRules:GetGameModeEntity().mychess[teamid]) do
	-- 				if v.index == uindex then
	-- 					table.insert(v.item,name)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
end
function FindValueInTable(tbl,value)
	local found = false
	for i,v in pairs(tbl) do
		if v == value then
			found = true
		end
	end
	return found
end
function CopyTable(origin_table)
	local new_table = {}
	if origin_table ~= nil then
		for k,v in pairs(origin_table) do
			table.insert(new_table,v)
		end
		return new_table
	else
		return {}
	end
end
function DiffTable(big_table,small_table)
	local temp_table  = {}
	for k,v in pairs(big_table) do
		table.insert(temp_table,v)
	end
	for k1,v1 in pairs(small_table) do
		RemoveOneKeyInTable(temp_table,v1)
	end
	if table.maxn(temp_table) > 0 then
		return temp_table
	else
		return {}
	end
end
function RemoveOneKeyInTable(tbl,key)
	local max = table.maxn(tbl)
	for i = max,1,-1 do
		if key == tbl[i] then
			table.remove(tbl,i)
			break
		end
	end
end
function DAC:OnEntityKilled(keys)
	local u = EntIndexToHScript(keys.entindex_killed)
	if u == nil then
		return
	end
	if u:IsHero() == true then
		return
	end
	if u:GetUnitName() == "invisible_unit" then
		return
	end
	if u:GetUnitName() == "chess_tech_bomb" then
		return
	end
	if u:GetUnitName() == "player_image" then
		return
	end
	if GameRules:GetGameModeEntity().game_status == 2 then
		if string.find(u:GetUnitName(),'pve') ~= nil then  --pve敌人掉宝
			DropItem(u)
		-- else
		-- 	if u:GetTeam() == 4 and RandomInt(1,100) < 10 then  --pvp的敌人也有概率掉宝
		-- 		DropItem(u)
		-- 	end
		end
		local xx = Vector2X(u:GetAbsOrigin(),u.at_team_id or u.team_id)
		local yy = Vector2Y(u:GetAbsOrigin(),u.at_team_id or u.team_id)
		-- local before = GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][u.y_x]
		-- if before == nil then
		-- 	before = 0
		-- end
		if u.at_team_id ~= nil or u.team_id ~= nil then
			if u.y_x ~= nil then
				GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][u.y_x] = nil
			end
		end
		RemoveFromToBeDestroyList(u)
		if u.team_id ~= 4 then
			-- prt('OnEntityKilled保存玩家'..u.team_id..' '..u:GetUnitName()..'的物品： ROUND '..GameRules:GetGameModeEntity().battle_round)
			SaveItem(u.team_id,u:entindex())
		end

		if u.at_team_id ~= nil then
			AddStat(TeamId2Hero(u.at_team_id):GetPlayerID(),'kills')
		end


	end
end
--游戏循环1.2——抽卡
function PrepareARound(teamid)
	Draw5ChessAndShow(teamid, false)
end
--游戏循环1.2.x——抽卡用到的方法(第二个参数可以指定下一个棋子)
function Draw5ChessAndShow(team_id, unlock)
	local h = TeamId2Hero(team_id)
	if h.chesslock == true then
		return
	end
	--把上次剩的洗回棋库
	if h.curr_chess_table ~= nil and table.maxn(h.curr_chess_table) > 0 then
		for _,chess in pairs(h.curr_chess_table) do
			AddAChessToChessPool(chess)
		end
	end
	h.curr_chess_table = {}
	--抽！
	local cards,curr_chess_table = RandomNDrawChessNew(team_id,5)
	h.curr_chess_table = curr_chess_table

	CustomGameEventManager:Send_ServerToTeam(team_id,"show_draw_card",{
		cards = cards,
		curr_money = h:GetMana(),
		unlock = unlock,
	})
end
function RandomNDrawChessNew(team_id,n)
	local new_chess_list_str = ""
	local new_chess_list_table = {}
	local chess_count = 0
		
	while chess_count < n do
		local new_chess = RandomDrawChessNew(team_id)
		if new_chess ~= nil then
			new_chess_list_str = new_chess_list_str..new_chess..','
			table.insert(new_chess_list_table,new_chess)
			chess_count = chess_count + 1
		end
	end
	return new_chess_list_str,new_chess_list_table
end
function RandomDrawChessNew(team_id)
	local h = TeamId2Hero(team_id)
	local this_chess = nil
	local ran = RandomInt(1,100)
	local chess_level = 1
	local curr_per = 0
	local hero_level = h:GetLevel()

	local table_11chess = {}
	for _,chess in pairs(GameRules:GetGameModeEntity().mychess[team_id]) do
		if string.find(chess.chess,'11') then
			table.insert(table_11chess,string.sub(chess.chess,1,-3))
		end
	end
	local ran1 = RandomInt(1,10000)
	local ran2 = RandomInt(1,10000)
	if h:GetLevel() >= 7 and ran1 <= 1 and ran2 <= 1 then
		this_chess = GameRules:GetGameModeEntity().chess_list_ssr[RandomInt(1,table.maxn(GameRules:GetGameModeEntity().chess_list_ssr))]
	else
		if GameRules:GetGameModeEntity().chess_gailv[hero_level] ~= nil then
			for per,lv in pairs(GameRules:GetGameModeEntity().chess_gailv[hero_level]) do
				if ran>per and curr_per<=per then
					curr_per = per
					chess_level = lv
				end
			end
		end
		-- this_chess = GameRules:GetGameModeEntity().chess_list_by_mana[chess_level][RandomInt(1,table.maxn(GameRules:GetGameModeEntity().chess_list_by_mana[chess_level]))]

		this_chess = DrawAChessFromChessPool(chess_level, table_11chess)
	end
	return this_chess
end
--选好卡进入等待区
function DAC:OnChessSelected(keys)
	local chess = keys.chess
	local team_id = keys.team
	local mana_required = GameRules:GetGameModeEntity().chess_2_mana[chess]
	if PlayerResource:GetPlayer(GameRules:GetGameModeEntity().team2playerid[team_id]) == nil then
		return
	end
	local h = TeamId2Hero(team_id)
	local mana = h:GetMana()
	if mana_required > mana then
		CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
			text = "text_mima_no_mana"
		})
		return
	end
	local index = FindEmptyHandSlot(team_id)
	if index == nil then
		CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
			text = "hand full"
		})
		return
	else
		if h.curr_chess_table ~= nil then
			if FindValueInTable(h.curr_chess_table,chess) == true then
				RemoveOneKeyInTable(h.curr_chess_table,chess)
			else
				return
			end
		end

		CostMana(h,mana_required)

		CustomGameEventManager:Send_ServerToTeam(team_id,"show_gold",{
			gold = h:GetMana(),
			lose_streak = h.lose_streak or 0,
			win_streak = h.win_streak or 0,
		})

		local x = nil
		local this_chess = nil
		this_chess = chess
		x = CreateUnitByName(this_chess,HandIndex2Vector(team_id,index),true,nil,nil,team_id)
		MakeTiny(x)
		PlayChessDialogue(x,'spawn')

		GameRules:GetGameModeEntity().hand[team_id][index] = 1
		-- prt(team_id..'手牌'..index..'占领')
		if h.hand_entities == nil then
			h.hand_entities = {}
		end

		h.hand_entities[index] = x

		x:SetForwardVector(Vector(0,1,0))
		x.hand_index = index
		x.team_id = team_id
		x.owner_player_id = GameRules:GetGameModeEntity().team2playerid[team_id]
		
		AddAbilityAndSetLevel(x,'root_self')
		AddAbilityAndSetLevel(x,'jiaoxie_wudi')

		play_particle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon_bright.vpcf",PATTACH_ABSORIGIN_FOLLOW,x,5)

		--添加战斗技能
		if GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()] ~= nil then
			local a = GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()]
			print(a)
			if x:FindAbilityByName(a) == nil then
				AddAbilityAndSetLevel(x,a,0)
			end
		end
		if TeamId2Hero(team_id):FindAbilityByName('h403_ability') ~= nil and use_crab == true then
			GameRules:GetGameModeEntity().next_crab = this_chess
		end
	end

	CustomGameEventManager:Send_ServerToTeam(team_id,"show_is_hand_full",{
		is_hand_full = IsHandFull(team_id)
	})

end
function IsHandFull(team_id)
	if FindEmptyHandSlot(team_id) == nil then
		return true
	else
		return false
	end
end
function FindEmptyHandSlot(team_id)
	local empty_index = nil
	for i=1,8 do
		if GameRules:GetGameModeEntity().hand[team_id][i] == 0 then
			empty_index = i
			break
		end
	end
	return empty_index
end
function CheckEmptyHandSlot(team_id,index)
	if GameRules:GetGameModeEntity().hand[team_id][index] == 0 then
		return true
	else
		return false
	end
end
function ClearHand(team_id)
	local h = TeamId2Hero(team_id)
	if h ~= nil and h.hand_entities ~= nil then
		for _,v in pairs(h.hand_entities) do
			if v ~= nil then
				v:ForceKill(false)
			end
		end
	end
	GameRules:GetGameModeEntity().population[team_id] = 0
	GameRules:GetGameModeEntity().hand[team_id] = {}
	GameRules:GetGameModeEntity().mychess[team_id] = {}
	ClearARound(team_id)
end


--游戏循环1.4——上场相关操作
function RecallChess(keys)
	--撤回手牌
	local picked_chess = keys.target
	local caster = keys.caster
	local team_id = picked_chess.team_id
	local origin_x = picked_chess.x
	local origin_y = picked_chess.y

	--TODO: 判断此时是什么阶段，准备阶段才允许撤回


	CancelPickChess(caster)

	if picked_chess.hand_index ~= nil then
		--已经在手牌了
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"mima",{
			text = "text_mima_must_select_a_chess_in_batle_ground"
		})
		EmitSoundOn("General.CastFail_NoMana",keys.caster)
		return
	end

	local target_index = FindEmptyHandSlot(team_id)
	
	if target_index == nil then
		--手牌已经满了
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"mima",{
			text = "text_mima_hand_is_full"
		})
		EmitSoundOn("General.CastFail_NoMana",keys.caster)
		return
	end

	RemoveAbilityAndModifier(picked_chess,'mana_cost1')
	RemoveAbilityAndModifier(picked_chess,'mana_cost2')
	RemoveAbilityAndModifier(picked_chess,'mana_cost3')
	RemoveAbilityAndModifier(picked_chess,'mana_cost4')
	RemoveAbilityAndModifier(picked_chess,'mana_cost5')

	GameRules:GetGameModeEntity().mychess[team_id][''..origin_y..'_'..origin_x] = nil
	GameRules:GetGameModeEntity().unit[team_id][''..origin_y..'_'..origin_x] = nil
	GameRules:GetGameModeEntity().hand[team_id][target_index] = 1
	-- prt(team_id..'手牌'..target_index..'占领')
	if caster.hand_entities == nil then
		caster.hand_entities = {}
	end

	caster.hand_entities[target_index] = picked_chess
	for p,vp in pairs(GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
		if vp:entindex() == picked_chess:entindex() then
			table.remove(GameRules:GetGameModeEntity().to_be_destory_list[team_id],p)
		end
	end

	--跳过去	
	picked_chess:SetForwardVector((HandIndex2Vector(team_id,target_index) - Vector(0,1,0)):Normalized())
	picked_chess.hand_index = target_index
	picked_chess.team_id = team_id
	picked_chess.owner_player_id = caster
	BlinkChessX({p=HandIndex2Vector(team_id,target_index),caster=picked_chess})
	GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] - 1

	--同步ui人口
	CustomGameEventManager:Send_ServerToTeam(team_id,"population",{
		max_count = GameRules:GetGameModeEntity().population_max[team_id],
		count = GameRules:GetGameModeEntity().population[team_id],
	})
	
	AddAbilityAndSetLevel(picked_chess,'root_self')
	AddAbilityAndSetLevel(picked_chess,'jiaoxie_wudi')

	--战斗技能变0
	if GameRules:GetGameModeEntity().chess_ability_list[picked_chess:GetUnitName()] ~= nil then
		local a = GameRules:GetGameModeEntity().chess_ability_list[picked_chess:GetUnitName()]
		if picked_chess:FindAbilityByName(a) ~= nil then
			picked_chess:FindAbilityByName(a):SetLevel(0)
		end
	end
	CustomGameEventManager:Send_ServerToTeam(team_id,"show_is_hand_full",{
		is_hand_full = IsHandFull(team_id)
	})
end
--多余的滚回去
function RandomRecallChess()
	for i=6,13 do
		local teamcount = GameRules:GetGameModeEntity().population[i]
		local teammax = GameRules:GetGameModeEntity().population_max[i]
		if teamcount > 0 and teammax < teamcount then
			local recall_amount = teamcount - teammax
			if recall_amount > 0 then
				CustomGameEventManager:Send_ServerToTeam(i,"mima",{
					text = "text_mima_chess_max_recall"
				})
			end
			local recalled = 0
			Timers:CreateTimer(function()
				if recalled < recall_amount then
					local smallest_chess = nil
					local smallest_level = 3
					for k,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[i]) do
						local a_level = 1
						if string.find(v:GetUnitName(),'1') then
							a_level = 2
						end
						if string.find(v:GetUnitName(),'11') then
							a_level = 3
						end
						if a_level < smallest_level and v.combining ~= true then
							smallest_chess = v
							smallest_level = a_level
						end
					end
					local target_index = FindEmptyHandSlot(i)
					if target_index == nil then
						RemoveChess({
							caster = GameRules:GetGameModeEntity().teamid2hero[i],
							target = smallest_chess
						})
					else
						RecallChess({
							caster = GameRules:GetGameModeEntity().teamid2hero[i],
							target = smallest_chess
						})
					end
					recalled = recalled + 1
				end
				return 0.05
			end)
		end
	end
end
function PickChess(keys)
	local target = keys.target
	local caster = keys.caster
	local team = target.team_id

	CancelPickChess(caster)

	AddAbilityAndSetLevel(target,'chess_picked')


	caster.picked_chess = target
	EmitSoundOn("ui.browser_click_right",caster)
	CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"show_cursor_hero_icon",{
		unit = target:GetUnitName()
	})
	caster:FindAbilityByName('pick_chess'):SetActivated(false)
	caster:FindAbilityByName('recall_chess'):SetActivated(false)
end
function GetMinionManaCost(u)
	local mana = 0
	if u:FindAbilityByName('mana_cost1') ~= nil then
		mana = 1
	end
	if u:FindAbilityByName('mana_cost2') ~= nil then
		mana = 2
	end
	if u:FindAbilityByName('mana_cost3') ~= nil then
		mana = 3
	end
	if u:FindAbilityByName('mana_cost4') ~= nil then
		mana = 4
	end
	if u:FindAbilityByName('mana_cost5') ~= nil then
		mana = 5
	end
	return mana
end
function CancelPickChess(u)
	if u.picked_chess ~= nil and u.picked_chess:IsNull() ~= true then
		u.picked_chess:RemoveAbility('chess_picked')
		u.picked_chess:RemoveModifierByName('modifier_chess_picked')
	end
	u.picked_chess = nil
	CustomGameEventManager:Send_ServerToTeam(u:GetTeam(),"show_cursor_hero_icon",{})
	if GameRules:GetGameModeEntity().game_status == 1 and GameRules:GetGameModeEntity().prepare_timer > 5 then
		u:FindAbilityByName('pick_chess'):SetActivated(true)
		u:FindAbilityByName('recall_chess'):SetActivated(true)
	end
end 
function DAC:OnCancelPickChessPosition(keys)
	local caster = PlayerId2Hero(keys.player_id)
	CancelPickChess(caster)
end
function DAC:OnPickChessPosition(keys)
	local p = Vector(keys.x,keys.y,keys.z)
	local caster = PlayerId2Hero(keys.player_id)
	local picked_chess = caster.picked_chess

	if picked_chess == nil or picked_chess:IsNull() == true or picked_chess:IsAlive() == false then
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"mima",{
			text = "text_mima_must_select_a_chess"
		})
		EmitSoundOn("General.CastFail_NoMana",keys.caster)
		return
	end

	CancelPickChess(caster)
	local x = Vector2X(p,caster:GetTeam())
	local y = Vector2Y(p,caster:GetTeam())

	local team_id = picked_chess.team_id
	local position = XY2Vector(x,y,team_id)
	local origin_p = picked_chess:GetAbsOrigin()
	local origin_x = Vector2X(origin_p,caster:GetTeam())
	local origin_y = Vector2Y(origin_p,caster:GetTeam())
	
	CustomGameEventManager:Send_ServerToTeam(team_id,"close_draw_card",{
		cards = cards
	})
	if origin_x == x and origin_y == y then
		return
	end
	--要放回手牌
	if CheckTargetPosInHand(p,team_id) ~= false then
		if picked_chess.hand_index ~= nil then
			CancelPickChess(caster)
			return
		end
		local target_index = CheckTargetPosInHand(p,team_id)

		--移除费用
		RemoveAbilityAndModifier(picked_chess,'mana_cost1')
		RemoveAbilityAndModifier(picked_chess,'mana_cost2')
		RemoveAbilityAndModifier(picked_chess,'mana_cost3')
		RemoveAbilityAndModifier(picked_chess,'mana_cost4')
		RemoveAbilityAndModifier(picked_chess,'mana_cost5')

		GameRules:GetGameModeEntity().mychess[team_id][''..origin_y..'_'..origin_x] = nil
		GameRules:GetGameModeEntity().hand[team_id][target_index] = 1
		GameRules:GetGameModeEntity().unit[team_id][''..origin_y..'_'..origin_x] = nil

		if caster.hand_entities == nil then
			caster.hand_entities = {}
		end

		caster.hand_entities[target_index] = picked_chess
		for p,vp in pairs(GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
			if vp:entindex() == picked_chess:entindex() then
				table.remove(GameRules:GetGameModeEntity().to_be_destory_list[team_id],p)
			end
		end

		--跳过去
		picked_chess:SetForwardVector((HandIndex2Vector(team_id,target_index)- picked_chess:GetAbsOrigin()):Normalized())
		BlinkChessX({p=HandIndex2Vector(team_id,target_index),caster=picked_chess})
		picked_chess.hand_index = target_index
		picked_chess.team_id = team_id
		picked_chess.owner_player_id = caster
		picked_chess.y_x = nil
		picked_chess.y = nil
		picked_chess.x = nil
		GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] - 1

		--同步ui人口
		CustomGameEventManager:Send_ServerToTeam(team_id,"population",{
			max_count = GameRules:GetGameModeEntity().population_max[team_id],
			count = GameRules:GetGameModeEntity().population[team_id],
		})
		
		AddAbilityAndSetLevel(picked_chess,'root_self')
		AddAbilityAndSetLevel(picked_chess,'jiaoxie_wudi')

		--战斗技能变0
		if GameRules:GetGameModeEntity().chess_ability_list[picked_chess:GetUnitName()] ~= nil then
			local a = GameRules:GetGameModeEntity().chess_ability_list[picked_chess:GetUnitName()]
			if picked_chess:FindAbilityByName(a) ~= nil then
				picked_chess:FindAbilityByName(a):SetLevel(0)
			end
		end
		-- setHandStatus(team_id)
		CustomGameEventManager:Send_ServerToTeam(team_id,"show_is_hand_full",{
			is_hand_full = IsHandFull(team_id)
		})
	else
		--要跳到场上
		if IsInAttackArea(Vector2X(p,team_id),Vector2Y(p,team_id)) == true then
			-- CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
			-- 	text = "text_mima_cannot_enter_attack_area"
			-- })
			-- CancelPickChess(caster)
			-- return
			local proper_pos = GetClosestAvailableArea(x,y,team_id)
			x = proper_pos.x
			y = proper_pos.y
			position = XY2Vector(x,y,team_id)
		end
		if IsInMap(Vector2X(p,team_id),Vector2Y(p,team_id)) == false then
			-- CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
			-- 	text = "text_mima_not_in_map"
			-- })
			-- CancelPickChess(caster)
			-- return
			local proper_pos = GetClosestAvailableArea(x,y,team_id)
			x = proper_pos.x
			y = proper_pos.y
			position = XY2Vector(x,y,team_id)
		end
		if IsBlocked(Vector2X(position,team_id),Vector2Y(position,team_id),team_id) ~= false then
			-- CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
			-- 	text = "text_mima_not_avilable_position"
			-- })
			-- EmitSoundOn("General.CastFail_NoMana",keys.caster)
			-- return
			local proper_pos = GetClosestEmptyArea(x,y,team_id)
			if proper_pos ~= nil then
				x = proper_pos.x
				y = proper_pos.y
				position = XY2Vector(x,y,team_id)
			else
				CustomGameEventManager:Send_ServerToTeam(team_id,"mima",{
					text = "text_mima_not_avilable_position"
				})
				EmitSoundOn("General.CastFail_NoMana",keys.caster)
				return
			end		
		end
		--跳过去
		if picked_chess.hand_index ~= nil then
			--是打出的手牌
			GameRules:GetGameModeEntity().hand[team_id][picked_chess.hand_index] = 0
			caster.hand_entities[picked_chess.hand_index] = nil
			picked_chess.hand_index = nil
			
			picked_chess:RemoveAbility('act_teleport')
			picked_chess:RemoveModifierByName('modifier_act_teleport')
			-- RemoveCostParticle(picked_chess)
			table.insert(GameRules:GetGameModeEntity().to_be_destory_list[team_id],picked_chess)
			GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] + 1

			--同步ui人口
			CustomGameEventManager:Send_ServerToTeam(team_id,"population",{
				max_count = GameRules:GetGameModeEntity().population_max[team_id],
				count = GameRules:GetGameModeEntity().population[team_id],
			})
			-- setHandStatus(team_id)
		else
			--是场上的牌
			GameRules:GetGameModeEntity().mychess[team_id][''..origin_y..'_'..origin_x] = nil
		end
		GameRules:GetGameModeEntity().mychess[team_id][''..y..'_'..x] = {
			index = picked_chess:entindex(),
			chess = picked_chess:GetUnitName(),
			item = {},
			x = x,
			y = y,
		}
		picked_chess.y_x = ''..y..'_'..x
		picked_chess.y = y
		picked_chess.x = x
		GameRules:GetGameModeEntity().unit[team_id][''..origin_y..'_'..origin_x] = nil
		GameRules:GetGameModeEntity().unit[team_id][''..y..'_'..x] = 1

		picked_chess:SetForwardVector((position-origin_p):Normalized())
		BlinkChessX({p=position,caster=picked_chess})
		Timers:CreateTimer((position-origin_p):Length2D()/1000+0.5,function()
			TriggerChessCombineAtGrid(x,y,team_id)
			CustomGameEventManager:Send_ServerToTeam(team_id,"show_is_hand_full",{
				is_hand_full = IsHandFull(team_id)
			})
		end)
	end
end
function BlinkChessX(keys)
	local caster = keys.caster
	local p = keys.p
	local team_id = caster.at_team_id or caster.team_id
	local x = Vector2X(p,team_id)
	local y = Vector2Y(p,team_id)
	local position = XY2Vector(x,y,team_id)

	caster.y_x = Vector2Y(position,team_id)..'_'..Vector2X(position,team_id)
	caster.y = Vector2Y(position,team_id)
	caster.x = Vector2X(position,team_id)
	caster:Stop()
	if caster:HasModifier("modifier_jump") then
		return
	end
	caster:AddNewModifier(caster,nil,"modifier_jump",{vx = position.x,vy = position.y})	
end
function RemoveChess(keys)
	local target = keys.target
	local caster = keys.caster
	local position = target:GetAbsOrigin()
	local team_id = target.team_id
	local x = Vector2X(position,team_id)
	local y = Vector2Y(position,team_id)

	if string.find(target:GetUnitName(),'chess_') == nil then
		return
	end

	if target.is_removing == true then
		return
	end	if (GameRules:GetGameModeEntity().game_status == 2 and target.hand_index == nil) or (GameRules:GetGameModeEntity().game_status == 1 and target.hand_index == nil and GameRules:GetGameModeEntity().prepare_timer > 33) then
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"mima",{
			text = "text_mima_cannot_delete_battle_chess"
		})
		EmitSoundOn("General.CastFail_NoMana",keys.caster)
		return
	end
	
	play_particle("particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf",PATTACH_ABSORIGIN_FOLLOW,target,3)
	EmitSoundOn("Hero_Lion.Voodoo",caster)
	if target.hand_index == nil then
		-- DeepPrintTable(GameRules:GetGameModeEntity().mychess[team_id])
		-- print(target.y_x)
		GameRules:GetGameModeEntity().mychess[team_id][target.y_x] = nil
		-- DeepPrintTable(GameRules:GetGameModeEntity().mychess[team_id])
		GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] - 1

		--同步ui人口
		CustomGameEventManager:Send_ServerToTeam(team_id,"population",{
			max_count = GameRules:GetGameModeEntity().population_max[team_id],
			count = GameRules:GetGameModeEntity().population[team_id],
		})
	else
		GameRules:GetGameModeEntity().hand[team_id][target.hand_index] = 0
		-- prt(team_id..'手牌'..target.hand_index..'清空')
		caster.hand_entities[target.hand_index] = nil
	end
	RemoveFromToBeDestroyList(target)
	if target.y_x ~= nil then
		GameRules:GetGameModeEntity().unit[team_id][target.y_x] = nil
	end

	CancelPickChess(caster)

	AddAChessToChessPool(target:GetUnitName())

	local children = target:GetChildren()
    for k,child in pairs(children) do
       if child:GetClassname() == "dota_item_wearable" then
           child:RemoveSelf()
       end
    end
	target.is_removing = true    
    AddAbilityAndSetLevel(target,'no_minimap_icon')
	target:SetModelScale(0.0001)
	AddAbilityAndSetLevel(target,'no_hp_bar')
	target:RemoveAbility('act_teleport')
	target:RemoveModifierByName('modifier_act_teleport')
	-- RemoveCostParticle(target)

    --1/2返还魔法
    -- if RandomInt(1,100) < 50 then
    	-- if caster:FindAbilityByName('h406_ability') ~= nil and RandomInt(1,100) < 25 then
    	-- 	AddMana(caster, target:GetLevel()*10)
    	-- 	EmitSoundOn("General.CoinsBig",caster)
    	-- else
    		AddMana(caster, target:GetLevel())
    	-- end
	    
	    CustomGameEventManager:Send_ServerToTeam(team_id,"show_gold",{
			gold = caster:GetMana(),
			lose_streak = caster.lose_streak or 0,
			win_streak = caster.win_streak or 0,
		})
	-- end
	for slot=0,8 do
		if target:GetItemInSlot(slot)~= nil then
			local name = target:GetItemInSlot(slot):GetAbilityName()
			if name ~= nil then
				DropItemAppointed(caster,target,name)
			end
		end
	end
	local last_chess = false
	if FindEmptyHandSlot(team_id) == 1 then
		last_chess = true
	end
	Timers:CreateTimer(3,function()
		target:Destroy()
		--小死灵法轮回转世
		-- if TeamId2Hero(team_id):FindAbilityByName('h404_ability') ~= nil and RandomInt(0,100) < 25 and last_chess == true then
		-- 	RandomOneChessInHand(team_id)
		-- end
	end)

	CustomGameEventManager:Send_ServerToTeam(team_id,"show_is_hand_full",{
		is_hand_full = IsHandFull(team_id)
	})
end
--触发team_id的场地中i,j这个格子的棋子合成
function TriggerChessCombineAtGrid(i,j,team_id)
	--找到这个格子上的棋子（obj）
	local curr_chess = GameRules:GetGameModeEntity().mychess[team_id][j..'_'..i]
	if curr_chess == nil then
		return
	end
	local chess_index = curr_chess.index
	local chess = EntIndexToHScript(chess_index)
	local chess_name = chess:GetUnitName()

	--在mychess中找到两个跟chess名字一样的chess obj：u1，u2
	local u1 = nil
	local u2 = nil
	for u,v in pairs(GameRules:GetGameModeEntity().mychess[team_id]) do
		if u1 == nil and v.index ~= chess_index and v.chess == chess_name and v.combining ~= true then
			u1 = v
		elseif u2 == nil and v.index ~= chess_index and v.chess == chess_name and v.combining ~= true then
			u2 = v
		end
	end
	local druid_count = GetDruidCount(team_id)

	--合成
	if u1 ~= nil and chess:FindAbilityByName('is_druid') ~= nil and EntIndexToHScript(u1.index):GetUnitName() == chess_name and string.find(chess_name,'1') == nil and druid_count >= 2 then
		--德鲁伊（2）：两个一样的1星可以合
		CombineChess(curr_chess,u1)
	elseif u1 ~= nil and EntIndexToHScript(chess_index):FindAbilityByName('is_druid') ~= nil and EntIndexToHScript(u1.index):GetUnitName() == chess_name and string.find(chess_name,'11') == nil and druid_count >= 4 then
		--德鲁伊（4）：两个一样的2星可以合
		CombineChess(curr_chess,u1)
	elseif u1 ~=nil and u2 ~=nil and EntIndexToHScript(u2.index):GetUnitName() == chess_name and EntIndexToHScript(u1.index):GetUnitName() == chess_name and string.find(chess_name,'11')  == nil then
		--普通情况：三个一样的可以合
		CombineChess(curr_chess,u1,u2)
	end
end
--把chess(unit)、u1(obj)、u2(obj)（可能有）合成chess1
function CombineChess(u0,u1,u2)
	if u0 == nil or u1 == nil then
		return
	end

	local chess0 = EntIndexToHScript(u0.index)
	local chess1 = EntIndexToHScript(u1.index)
	local chess2
	local chess_name = chess0:GetUnitName()
	local team_id = chess0.team_id
	local p = XY2Vector(chess0.x,chess0.y,team_id)
	local y = u0.y
	local x = u0.x

	local u0_key = u0.y..'_'..u0.x
	local u1_key = u1.y..'_'..u1.x
	local u2_key
	u0.combining = true
	u1.combining = true
	if u2 ~= nil then
		u2.combining = true
		u2_key = u2.y..'_'..u2.x
		chess2 = EntIndexToHScript(u2.index)
	end

	--合成
	local advance_unit_name = chess_name..'1'
	if advance_unit_name ~= nil then
		--收集低级棋子的物品
		local items_table = {}
		for slot=0,8 do
			if chess0:GetItemInSlot(slot)~= nil then
				table.insert(items_table,chess0:GetItemInSlot(slot):GetAbilityName())
			end
			if chess1:GetItemInSlot(slot)~= nil then
				table.insert(items_table,chess1:GetItemInSlot(slot):GetAbilityName())
			end
			if chess2 ~= nil and chess2:GetItemInSlot(slot)~= nil then
				table.insert(items_table,chess2:GetItemInSlot(slot):GetAbilityName())
			end
		end

		--移除三个低级棋子
		GameRules:GetGameModeEntity().mychess[team_id][u0_key]= nil
		GameRules:GetGameModeEntity().mychess[team_id][u1_key] = nil
		GameRules:GetGameModeEntity().unit[team_id][u1_key] = nil
		RemoveFromToBeDestroyList(chess0)
		RemoveFromToBeDestroyList(chess1)
		chess0:Destroy()
		chess1:Destroy()
		
		if u2 ~= nil then
			GameRules:GetGameModeEntity().mychess[team_id][u2_key] = nil
			GameRules:GetGameModeEntity().unit[team_id][u2_key] = nil
			RemoveFromToBeDestroyList(chess2)
			chess2:Destroy()
		end
		

		--造高级棋子
		local uu = CreateUnitByName(advance_unit_name, p,false,nil,nil,team_id) 
		MakeTiny(uu)
		PlayChessDialogue(uu,'merge')
		
		--给高级棋子添加棋子技能
		if GameRules:GetGameModeEntity().chess_ability_list[uu:GetUnitName()] ~= nil then
			local a = GameRules:GetGameModeEntity().chess_ability_list[uu:GetUnitName()]
			if uu:FindAbilityByName(a) == nil then
				AddAbilityAndSetLevel(uu,a,0)
			end
		end

		--添加星星特效
		if string.find(advance_unit_name,'11') ~= nil then
			play_particle('effect/arrow/star3.vpcf',PATTACH_OVERHEAD_FOLLOW,uu,5)
		elseif string.find(advance_unit_name,'1') ~= nil then 
			play_particle('effect/arrow/star2.vpcf',PATTACH_OVERHEAD_FOLLOW,uu,5)
		end

		table.insert(GameRules:GetGameModeEntity().to_be_destory_list[team_id],uu)
		GameRules:GetGameModeEntity().mychess[team_id][''..y..'_'..x] = {
			index = uu:entindex(),
			chess = uu:GetUnitName(),
			item = {},
			x = x,
			y = y,
		}
		uu.y_x = ''..y..'_'..x
		uu.y = y
		uu.x = x
		uu.team_id = team_id

		uu:SetForwardVector(Vector(0,1,0))
		--添加装备
		for l,vl in pairs(items_table) do
			uu:AddItemByName(vl)
		end
		AddAbilityAndSetLevel(uu,'root_self')
		AddAbilityAndSetLevel(uu,'jiaoxie_wudi')
		--合成特效
		play_particle("particles/units/unit_greevil/loot_greevil_death.vpcf",PATTACH_ABSORIGIN_FOLLOW,uu,3)
		EmitGlobalSound("Loot_Drop_Stinger_Rare")

		GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] - 1
		if u2 ~= nil then
			GameRules:GetGameModeEntity().population[team_id] = GameRules:GetGameModeEntity().population[team_id] - 1
		end

		--同步ui人口
		CustomGameEventManager:Send_ServerToTeam(team_id,"population",{
			max_count = GameRules:GetGameModeEntity().population_max[team_id],
			count = GameRules:GetGameModeEntity().population[team_id],
		})

		--发弹幕
		CustomGameEventManager:Send_ServerToAllClients("bullet",{
			player_id = TeamId2Hero(team_id):GetPlayerID(),
			target = advance_unit_name,
		})

		-- ShowCombat({
		-- 	t = 'combine',
		-- 	player = TeamId2Hero(team_id):GetPlayerID(),
		-- 	text = advance_unit_name
		-- })

		--检测能否进一步合成
		Timers:CreateTimer(1,function()
			TriggerChessCombineAtGrid(x,y,team_id)
		end)
	end
end

function GetDruidCount(team_id)
	--德鲁伊种族技能
	--统计有多少不同的德鲁伊
	local druid_table = {}
	for w,vw in pairs(GameRules:GetGameModeEntity().mychess[team_id]) do
		local find_name = vw.chess
		if string.find(find_name,'11') ~= nil then
			find_name = string.sub(find_name,1,-2)
		end
		if string.find(find_name,'1') ~= nil then
			find_name = string.sub(find_name,1,-2)
		end
		if (find_name == "chess_eh" or find_name == "chess_ld" or find_name == "chess_tp" or find_name == "chess_fur") and FindValueInTable(druid_table,find_name) ~= true then
			table.insert(druid_table,find_name)
		end
	end
	return table.maxn(druid_table) or 0
end

function SyncHP(hero)
	GameRules:GetGameModeEntity().stat_info[hero.steam_id]['hp'] = hero:GetHealth()
	CustomNetTables:SetTableValue( "dac_table", "user_panel_ranking", {table = GameRules:GetGameModeEntity().stat_info, hehe = RandomInt(1,1000)})

	--同步ui血量
	CustomGameEventManager:Send_ServerToAllClients("sync_hp",{
		player_id = hero:GetPlayerID(),
		hp = hero:GetHealth(),
		hp_max = hero:GetMaxHealth(),
	})

	if GameRules:GetGameModeEntity().START_TIME == nil then
		return
	end
	SetStat(hero:GetPlayerID(), 'duration', math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME))
	SetStat(hero:GetPlayerID(), 'round', GameRules:GetGameModeEntity().battle_round)
	if hero:GetHealth() <= 0 then
		--玩家死亡

		--保存最终阵容
		local lineup = ''
		for _,v in pairs(GameRules:GetGameModeEntity().mychess[hero:GetTeam()]) do
			if v ~= nil and v.chess ~= nil then 
				lineup = lineup..v.chess..','
				AddAChessToChessPool(v.chess)
			end
		end
		--洗回手牌
		if hero.hand_entities ~= nil then
			for i=1,8 do
				local unitname = ''
				if hero.hand_entities[i] ~= nil then
					unitname = hero.hand_entities[i]:GetUnitName()
					AddAChessToChessPool(unitname)
				end
			end
		end
		SetStat(hero:GetPlayerID(), 'chess_lineup',lineup)
		
		hero:ForceKill(false)
		if GameRules:GetGameModeEntity().death_stack == nil then
			GameRules:GetGameModeEntity().death_stack = hero.steam_id
		else
			if string.find(GameRules:GetGameModeEntity().death_stack,hero.steam_id) == nil then
				GameRules:GetGameModeEntity().death_stack = hero.steam_id..','..GameRules:GetGameModeEntity().death_stack
			end
		end

		--统计还有多少活着的玩家
		local live_count = 0
		local last_hero = nil
		GameRules:GetGameModeEntity().last_player_steamid = nil
		GameRules:GetGameModeEntity().last_player_hero = nil
		for i,v in pairs (GameRules:GetGameModeEntity().hero) do
			if v ~= nil and v:IsNull() ~= true and v:IsAlive() == true then
				last_hero = v
				live_count = live_count + 1
				GameRules:GetGameModeEntity().last_player_steamid = v.steam_id
				GameRules:GetGameModeEntity().last_player_hero = v
			end
		end
		if live_count == 1 and PlayerResource:GetPlayerCount() > 1 then
			local dur = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME)+3
			SetStat(GameRules:GetGameModeEntity().last_player_hero:GetPlayerID(), 'duration', dur)
			SetStat(GameRules:GetGameModeEntity().last_player_hero:GetPlayerID(), 'round', GameRules:GetGameModeEntity().battle_round)
			-- last_hero:ForceKill(false)

			--保存最终阵容
			local lineup = ''
			for _,v in pairs(GameRules:GetGameModeEntity().mychess[last_hero:GetTeam()]) do
				if v ~= nil and v.chess ~= nil then 
					lineup = lineup..v.chess..','
				end
			end
			SetStat(last_hero:GetPlayerID(), 'chess_lineup',lineup)
			

			if GameRules:GetGameModeEntity().already_sent == nil then
				GameRules:GetGameModeEntity().already_sent = 1
				prt('END GAME')
				GameRules:GetGameModeEntity().death_stack = GameRules:GetGameModeEntity().last_player_steamid..','..GameRules:GetGameModeEntity().death_stack
				if GetMapName() ~= 'practice' then 
					local url = "http://autochess.ppbizon.com/game/post/@"..GameRules:GetGameModeEntity().death_stack.."?hehe="..RandomInt(1,10000).."&winner_lineup="..lineup.."&duration="..dur.."&key="..GetDedicatedServerKey('dac')
					SendHTTP(url.."&from=SyncHP", function(t)
						if t.err == 0 then
							prt('POST GAME OK!')
							for u,v in pairs(t.mmr_info) do
								GameRules:GetGameModeEntity().stat_info[u]['mmr_level'] = v.level
								GameRules:GetGameModeEntity().stat_info[u]['candy'] = v.candy or 0
							end
							print('POST GAME OK!')
							
							--展示结束面板，结束游戏！
							PostGame()
							Timers:CreateTimer(3,function()
								GameRules:SetGameWinner(last_hero:GetTeam())
							end)
							SendMaxData(t,dur)
						else
							prt('POST GAME ERROR : '..t.err)
							PostGame()
							Timers:CreateTimer(3,function()
								GameRules:SetGameWinner(last_hero:GetTeam())
								
							end)
						end
					end, function()
						prt('POST GAME ERROR')
						PostGame()
						Timers:CreateTimer(3,function()
							GameRules:SetGameWinner(last_hero:GetTeam())
							
						end)
					end)
				else
					PostGame()
					Timers:CreateTimer(3,function()
						GameRules:SetGameWinner(last_hero:GetTeam())
						
					end)
				end

				--提交阵容
				if table.maxn(GameRules:GetGameModeEntity().upload_lineup) > 0 then
					local str = ''
					for i,v in pairs(GameRules:GetGameModeEntity().upload_lineup) do
						str = str..json.encode(v)..'|'
					end
					str = string.sub(str,1,-2)
					local url_up = "http://autochess.ppbizon.com/lineup/add?lineups="..str.."&hehe="..RandomInt(1,10000).."&key="..GetDedicatedServerKey('dac')
					local req_up = CreateHTTPRequestScriptVM("GET", url_up)
					req_up:SetHTTPRequestAbsoluteTimeoutMS(20000)
					req_up:Send(function (result)
						local t_up = json.decode(result["Body"])
						if t_up.err == 0 then
							prt('SAVE CLOUD LINEUP OK!')
						end
					end)
				end
			end
		end
		if live_count == 0 and PlayerResource:GetPlayerCount() == 1 then
			PostGame()
			Timers:CreateTimer(3,function()
				GameRules:SetGameWinner(DOTA_TEAM_NEUTRALS)
				
			end)
		end
	end
end
function PostGame()
	CustomNetTables:SetTableValue( "dac_table", "end_board", { data = GameRules:GetGameModeEntity().stat_info, hehe = RandomInt(1,100000)})
end
function LoadPVEEnemy(wave,team)
	if GameRules:GetGameModeEntity().battle_boss[wave] ~= nil then
		for i,vi in pairs(GameRules:GetGameModeEntity().battle_boss[wave]) do
			GameRules:GetGameModeEntity().unit[team][vi.y..'_'..vi.x] = 1
			local x = CreateUnitByName(vi.enemy,XY2Vector(vi.x,vi.y,team),true,nil,nil,DOTA_TEAM_NEUTRALS)
			x:SetForwardVector(Vector(0,-1,0))
			x.y_x = vi.y..'_'..vi.x
			x.y = vi.y
			x.x = vi.x
			x.team_id = 4
			x.at_team_id = team
			AddAbilityAndSetLevel(x,'root_self')
			AddAbilityAndSetLevel(x,'jiaoxie_wudi')
			table.insert(GameRules:GetGameModeEntity().to_be_destory_list[team],x)
		end
	end
	Timers:CreateTimer(0.5,function()
		AddComboAbility(team)
	end)
end
--掉宝
function DropItem(unit)
	local ran = RandomInt(1,100)
	local item_level = 0
	local curr_per = 0
	local unit_level = unit:GetLevel()
	if GameRules:GetGameModeEntity().drop_item_gailv[unit_level] ~= nil then
		for per,lv in pairs(GameRules:GetGameModeEntity().drop_item_gailv[unit_level]) do
			if ran >= per and curr_per<=per then
				curr_per = per
				item_level = lv
			end
		end
	end
	local ITEM_LIST = {
		[1] = {
			[1] = 'item_suozijia',
			[2] = 'item_yuandun',
			[3] = 'item_zhiliaozhihuan',
			[4] = 'item_gongjizhizhua',
			[5] = 'item_kuweishi',
			[6] = 'item_duangun',
			[7] = 'item_xixuemianju',
			[8] = 'item_huifuzhihuan',
			[9] = 'item_kangmodoupeng',
			[10] = 'item_xuwubaoshi',
			[11] = 'item_fashichangpao',
			[12] = 'item_wangguan',
		},
		[2] = {
			[1] = 'item_banjia', 	
			[2] = 'item_huoliqiu',
			[3] = 'item_kuojian',
			[4] = 'item_miyinchui',
			[5] = 'item_biaoqiang',
			[6] = 'item_molifazhang',
			[7] = 'item_tiaodao',
		},
		[3] = {
			[1] = 'item_emodaofeng',
			[2] = 'item_zhenfenbaoshi',
			[3] = 'item_jixianfaqiu',
		},
		[4] = {
			[1] = 'item_shengzheyiwu',
			[2] = 'item_dafu',
			[3] = 'item_shenmifazhang',
		},
	}
	if item_level > 0 then
		local hero = TeamId2Hero(unit.at_team_id )
		local i = ITEM_LIST[item_level][RandomInt(1,table.maxn(ITEM_LIST[item_level]))]
		local newItem = CreateItem( i, hero, hero )
		local drop = CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), newItem )
		local dropRadius = RandomFloat( 50, 200 )
		newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, unit:GetAbsOrigin() + RandomVector(dropRadius ))
	end
end
function DropItemAppointed(hero,unit,item)
	local newItem = CreateItem( item, hero, hero )
	local drop = CreateItemOnPositionForLaunch(unit:GetAbsOrigin(), newItem )
	local dropRadius = RandomFloat( 10, 100 )
	if unit == nil or unit:IsNull() == true or unit:GetAbsOrigin() == nil then
		unit = hero
	end
	newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, unit:GetAbsOrigin() + RandomVector(dropRadius ))
end
function StartAPVERound()
	GameRules:GetGameModeEntity().battle_count = 0

	CustomGameEventManager:Send_ServerToAllClients("battle_info",{
		type = "pve",
		text = ''..GameRules:GetGameModeEntity().battle_round,
		round = GameRules:GetGameModeEntity().battle_round,
	})

	for i,v in pairs (GameRules:GetGameModeEntity().counterpart) do
		if v ~= -1 then
			v = 0
			local h = TeamId2Hero(i)
			CheckChess(i)
			CancelPickChess(h)
			LoadPVEEnemy(GameRules:GetGameModeEntity().battle_round,i)
			local mana = h:GetMana()
			if mana>5 then
				mana = 5
			end

			--主公技可用
			Timers:CreateTimer(3,function()
				SetLordAbilityEnable(h,true)
			end)
		end
	end
	for m,n in pairs (GameRules:GetGameModeEntity().to_be_destory_list) do
		if table.maxn(n) > 0 then
			GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count + 1
			SaveMaxObj(m)
			Timers:CreateTimer(function()
				if GameRules:GetGameModeEntity().battle_timer <= 0 then
					GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
					-- prt('玩家'..m..'防守成功，因为时间到了')
					EmitGlobalSound('crowd.lv_01')
					AddStat(TeamId2Hero(m):GetPlayerID(),'draw_round')
					--发弹幕
					-- CustomGameEventManager:Send_ServerToAllClients("bullet",{
					-- 	player_id = TeamId2Hero(m):GetPlayerID(),
					-- 	win = 0,
					-- 	draw = 'pve_'..(GameRules:GetGameModeEntity().battle_round-1),
					-- 	lose = nil,
					-- 	score = '0-0',
					-- })
					ShowCombat({
						t = 'battle_pve_draw',
						player = TeamId2Hero(m):GetPlayerID(),
						text = '#pve_'..(GameRules:GetGameModeEntity().battle_round-1),
					})
					return
				else
					local mychess = 0
					local enemychess = 0
					local my_last_chess = nil
					for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[m]) do
						if q.team_id == m then
							mychess = mychess + 1
							my_last_chess = q
						else
							enemychess = enemychess + 1
						end
					end
					if enemychess == 0 then
						GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
						for a,b in pairs(n) do
							AddAbilityAndSetLevel(b,'act_victory')
							b.alreadywon = true
						end
						-- prt('玩家'..m..'防守成功，因为杀光了所有敌人（'..mychess..':'..enemychess..'）')
						--发弹幕
						-- CustomGameEventManager:Send_ServerToAllClients("bullet",{
						-- 	player_id = TeamId2Hero(m):GetPlayerID(),
						-- 	win = 'pve_'..(GameRules:GetGameModeEntity().battle_round-1),
						-- 	draw = nil,
						-- 	lose = nil,
						-- 	score = mychess..'-0',
						-- })
						ShowCombat({
							t = 'battle_pve_win',
							player = TeamId2Hero(m):GetPlayerID(),
							text = '#pve_'..(GameRules:GetGameModeEntity().battle_round-1),
							num = mychess,
						})

						EmitGlobalSound('crowd.lv_01')
						AddStat(TeamId2Hero(m):GetPlayerID(),'win_round')
						if my_last_chess ~= nil then
							PlayChessDialogue(my_last_chess,'win')
						end
						return
					elseif mychess == 0 then
						Timers:CreateTimer(0.5,function()
							local enemychess_new = 0
							for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[m]) do
								if q.team_id ~= m then
									enemychess_new = enemychess_new + 1
								end
							end
							if enemychess_new == 0 then
								GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
								for a,b in pairs(n) do
									AddAbilityAndSetLevel(b,'act_victory')
									b.alreadywon = true
								end
								--发弹幕
								-- CustomGameEventManager:Send_ServerToAllClients("bullet",{
								-- 	player_id = TeamId2Hero(m):GetPlayerID(),
								-- 	win = nil,
								-- 	draw = 'pve_'..(GameRules:GetGameModeEntity().battle_round-1),
								-- 	lose = nil,
								-- 	score = mychess..'-0',
								-- })
								ShowCombat({
									t = 'battle_pve_win',
									player = TeamId2Hero(m):GetPlayerID(),
									text = '#pve_'..(GameRules:GetGameModeEntity().battle_round-1),
									num = mychess,
								})

								EmitGlobalSound('crowd.lv_01')
								AddStat(TeamId2Hero(m):GetPlayerID(),'draw_round')
							else
								GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1

								local hero = TeamId2Hero(m)
								local curr_hp = hero:GetHealth()
								local delay_time = 0
								local damage_all = 0
								for a,b in pairs(n) do
									AddAbilityAndSetLevel(b,'act_victory')
									b.alreadywon = true
									--主公掉血弹道
									local info =
									    {
									        Target = hero,
									        Source = b,
									        Ability = nil,
									        EffectName = "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
									        bDodgeable = false,
									        iMoveSpeed = 1000,
									        bProvidesVision = false,
									        iVisionRadius = 0,
									        iVisionTeamNumber = b:GetTeamNumber(),
									        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
									    }
									projectile = ProjectileManager:CreateTrackingProjectile(info)

								    delay_time = (hero:GetAbsOrigin() - b:GetAbsOrigin()):Length2D() / 1000  --delay time取最后一个
								    damage_all = damage_all + math.floor(GetHitDamage(b) or 1)
								    AddStat(hero:GetPlayerID(),'deaths')
								end

								damage_all = damage_all
								local after_hp = curr_hp - damage_all--*1000 --千倍伤害
								if after_hp <= 0 then
									after_hp = 0
								end

								Timers:CreateTimer(delay_time,function()
									if after_hp <= 0 then
										--死了
										hero:ForceKill(false)
										GameRules:GetGameModeEntity().counterpart[hero:GetTeam()] = -1
										SyncHP(hero)
										AMHC:CreateNumberEffect(hero,damage_all,2,AMHC.MSG_MISS,"red",9)
										ClearHand(hero:GetTeam())
										return
									end
									hero:SetHealth(after_hp)
									SyncHP(hero)
									AMHC:CreateNumberEffect(hero,damage_all,2,AMHC.MSG_MISS,"red",9)
									EmitSoundOn("Frostivus.PointScored.Enemy",hero)
								end)
								--发弹幕
								-- CustomGameEventManager:Send_ServerToAllClients("bullet",{
								-- 	player_id = TeamId2Hero(m):GetPlayerID(),
								-- 	win = nil,
								-- 	draw = nil,
								-- 	lose = 'pve_'..(GameRules:GetGameModeEntity().battle_round-1),
								-- 	score = '0-'..enemychess_new,
								-- })
								ShowCombat({
									t = 'battle_pve_lose',
									player = TeamId2Hero(m):GetPlayerID(),
									text = '#pve_'..(GameRules:GetGameModeEntity().battle_round-1),
									num = enemychess_new,
								})
								
								EmitGlobalSound('crowd.lv_01')
								AddStat(TeamId2Hero(m):GetPlayerID(),'lose_round')
							end
							return
						end)
					else
						return 1
					end
				end
			end)
		end
	end
	Timers:CreateTimer(function()
		if GameRules:GetGameModeEntity().battle_timer <= 0 then
			GameRules:GetGameModeEntity().game_status = 1
			-- GameRules:SendCustomMessage('准备回合',0,0)
			StartAPrepareRound()
			return
		elseif GameRules:GetGameModeEntity().battle_count == 0 and GameRules:GetGameModeEntity().battle_timer >= 3 then
			Timers:CreateTimer(3,function()
				GameRules:GetGameModeEntity().game_status = 1
				-- GameRules:SendCustomMessage('准备回合',0,0)
				StartAPrepareRound()
				return
			end)
		else
			local center_index = ''..Entities:FindByName(nil,"center0"):entindex()..','..Entities:FindByName(nil,"center1"):entindex()..','..Entities:FindByName(nil,"center2"):entindex()..','..Entities:FindByName(nil,"center3"):entindex()..','..Entities:FindByName(nil,"center4"):entindex()..','..Entities:FindByName(nil,"center5"):entindex()..','..Entities:FindByName(nil,"center6"):entindex()..','..Entities:FindByName(nil,"center7"):entindex()
			--发送当前游戏时间给客户端
			CustomGameEventManager:Send_ServerToAllClients("show_time",{
				timer_round = GameRules:GetGameModeEntity().battle_timer,
				round_status = "battle",
				total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME),
				center_index = center_index,
			})
			GameRules:GetGameModeEntity().battle_timer = GameRules:GetGameModeEntity().battle_timer - 1
			return 1
		end
	end)
	Timers:CreateTimer(0.1,function()
		--添加战斗技能
		for t = 6,13 do
			for _,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[t]) do
				if GameRules:GetGameModeEntity().chess_ability_list[v:GetUnitName()] ~= nil then
					local a = GameRules:GetGameModeEntity().chess_ability_list[v:GetUnitName()]

					local a_level = 1
					if string.find(v:GetUnitName(),'1') then
						a_level = 2
					end
					if string.find(v:GetUnitName(),'11') then
						a_level = 3
					end

					if v:FindAbilityByName(a) == nil then
						AddAbilityAndSetLevel(v,a,a_level)
					else
						v:FindAbilityByName(a):SetLevel(a_level)
					end
					v:RemoveAbility('jiaoxie_wudi')
					v:RemoveModifierByName('modifier_jiaoxie_wudi')
					if v.is_dragon_zhanhou == nil then
						v:SetMana(0)
					end
				end
				Timers:CreateTimer(function()
					if v == nil or v:IsNull() == true or v:IsAlive() == false and v.alreadywon == true then
						return
					end
					ChessAI(v)
					return 1
				end)
			end
		end
	end)
end
function SaveMaxObj(team)
	local inserttable = {}
	for _,insertchess in pairs(GameRules:GetGameModeEntity().mychess[team]) do
		table.insert(inserttable,{
			x = insertchess.x,
			y = insertchess.y,
			chess = insertchess.chess
		})
	end
	local maxobj = {
		owner = TeamId2Hero(team).steam_id,
		lineup = inserttable,
		round = GameRules:GetGameModeEntity().battle_round - 1
	}
	table.insert(GameRules:GetGameModeEntity().upload_detail_stat[TeamId2Hero(team).steam_id],maxobj)
end
--查户口
function CheckChess(team_id)
	local index_table = {}
	local dup_table = {}
	local chess_count = 0
	local hero_level = TeamId2Hero(team_id):GetLevel()
	for y_x,obj in pairs(GameRules:GetGameModeEntity().mychess[team_id]) do
		if FindValueInTable(index_table,obj.index) == true then
			--重复了
			table.insert(dup_table,y_x)
		else
			table.insert(index_table,obj.index)
		end
		chess_count = chess_count + 1
	end
	GameRules:GetGameModeEntity().population[team_id] = chess_count
	GameRules:GetGameModeEntity().population_max[team_id] = hero_level
	
	if chess_count > hero_level and table.maxn(dup_table) > 0 then
		prt('CHECK CHESS')
		prt('hero_level:'..hero_level..'/chess_count:'..chess_count)
		for _,y_x in pairs(dup_table) do
			prt('DELETE:'..y_x)
			GameRules:GetGameModeEntity().mychess[team_id][y_x] = nil
		end
	end
end
function StartAPVPRound()
	--分配对阵（无延时）
	AllocateABattleRound()
	local send_table = {}
	for p,vp in pairs(GameRules:GetGameModeEntity().counterpart) do
		send_table[p] = GameRules:GetGameModeEntity().team2playerid[vp]
	end

	--为每个场地加载敌人（延时0.1-0.5秒）
	for i,v in pairs (GameRules:GetGameModeEntity().counterpart) do
		if v ~= -1 then
			local h = TeamId2Hero(i)
			-- if h.hand_entities ~= nil then
			-- 	for _,ent in pairs(h.hand_entities) do
			-- 		AddAbilityAndSetLevel(ent,'outofgame',1)
			-- 	end
			-- end
			--CheckChess(i)
			CancelPickChess(h)
			if PlayerResource:GetPlayerCount() == 1 and GameRules:GetGameModeEntity().cloudlineup[''..GameRules:GetGameModeEntity().battle_round] ~= nil then
				local chesses = nil
				for _,data in pairs(GameRules:GetGameModeEntity().cloudlineup[''..GameRules:GetGameModeEntity().battle_round]) do
					chesses = json.decode(data)
				end
				--打云玩家
				CustomGameEventManager:Send_ServerToAllClients("battle_info",{
					type = "cloud",
					text = chesses.owner,
					round = GameRules:GetGameModeEntity().battle_round,
				})
				LoadCloudEnemy(GameRules:GetGameModeEntity().battle_round,i)
				h.cloud_opp_name = chesses.owner
			else
				--打pvp敌人
				local enemy_id = TeamId2Hero(v):GetPlayerID()
				CustomGameEventManager:Send_ServerToTeam(i,"battle_info",{
					type = "pvp",
					text = enemy_id,
					round = GameRules:GetGameModeEntity().battle_round,
				})
				MirrorARound(i)
				h.cloud_opp_name = nil
			end
		end
	end
	GameRules:GetGameModeEntity().battle_count = 0

	--添加战斗技能和棋子AI（延时1秒）
	Timers:CreateTimer(1,function()
		for t = 6,13 do
			for _,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[t]) do
				if GameRules:GetGameModeEntity().chess_ability_list[v:GetUnitName()] ~= nil then
					local a = GameRules:GetGameModeEntity().chess_ability_list[v:GetUnitName()]

					local a_level = 1
					if string.find(v:GetUnitName(),'1') then
						a_level = 2
					end
					if string.find(v:GetUnitName(),'11') then
						a_level = 3
					end

					if v:FindAbilityByName(a) == nil then
						AddAbilityAndSetLevel(v,a,a_level)
					else
						v:FindAbilityByName(a):SetLevel(a_level)
					end
					v:RemoveAbility('jiaoxie_wudi')
					v:RemoveModifierByName('modifier_jiaoxie_wudi')

					if v.is_dragon_zhanhou == nil then
						v:SetMana(0)
					end
					Timers:CreateTimer(function()
						if v == nil or v:IsNull() == true or v:IsAlive() == false and v.alreadywon == true then
							return
						end
						ChessAI(v)
						return 1
					end)
				end
			end
		end
	end)

	--启动判断每个场地胜负的计时器（延时2秒）
	Timers:CreateTimer(2,function()
		for team = 6,13 do
			if GameRules:GetGameModeEntity().counterpart[team] ~= nil then
				GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count + 1
				StartWinLoseDrawTimerForTeam(team)
				SaveMaxObj(team)
			end
		end
	end)

	--判断分是否战斗回合结束、进入准备回合的计时器（延时3秒）
	Timers:CreateTimer(3,function()
		if GameRules:GetGameModeEntity().battle_timer <= 0 then
			--战斗时间到了，进入准备回合
			GameRules:GetGameModeEntity().game_status = 1
			StartAPrepareRound()
			return
		elseif GameRules:GetGameModeEntity().battle_count == 0 and GameRules:GetGameModeEntity().battle_timer >= 3 then
			--没有正在战斗的了，进入准备回合
			Timers:CreateTimer(3,function()
				GameRules:GetGameModeEntity().game_status = 1
				StartAPrepareRound()
				return
			end)
			return
		else
			--还有正在战斗的，发送时间给客户端
			local center_index = ''..Entities:FindByName(nil,"center0"):entindex()..','..Entities:FindByName(nil,"center1"):entindex()..','..Entities:FindByName(nil,"center2"):entindex()..','..Entities:FindByName(nil,"center3"):entindex()..','..Entities:FindByName(nil,"center4"):entindex()..','..Entities:FindByName(nil,"center5"):entindex()..','..Entities:FindByName(nil,"center6"):entindex()..','..Entities:FindByName(nil,"center7"):entindex()
			--发送当前游戏时间给客户端
			CustomGameEventManager:Send_ServerToAllClients("show_time",{
				timer_round = GameRules:GetGameModeEntity().battle_timer,
				round_status = "battle",
				total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().START_TIME),
				center_index = center_index
			})
			GameRules:GetGameModeEntity().battle_timer = GameRules:GetGameModeEntity().battle_timer - 1
			return 1
		end
	end)
end
--为指定队伍的场地开启一个胜平负判断计时器
function StartWinLoseDrawTimerForTeam(m)
	Timers:CreateTimer(3,function()
		if GameRules:GetGameModeEntity().battle_timer <= 0 then
			--第一种情况：时间到了，平局
			DrawARound(m)
			return
		end
		
		--统计活着的敌我单位数量
		local mychess,enemychess,my_last_chess = GetChessCountInBattleGround(m)

		if mychess == 0 and enemychess == 0 then
			--第二种情况，敌我都没人了，平局
			DrawARound(m)
			return
		end

		if mychess > 0 and enemychess == 0 then
			--第三种情况：敌方死光了，获胜
			WinARound(m,mychess,my_last_chess)
			return
		elseif mychess == 0 then
			Timers:CreateTimer(0.5,function()
				--重新统计活着的敌我单位数量
				local mychess,enemychess_new,my_last_chess = GetChessCountInBattleGround(m)
				if enemychess_new == 0 then
					--第四种情况：敌我都死光了，平局
					DrawARound(m)
					return
				else
					--第五种情况：只剩敌人了，失败
					LoseARound(m,enemychess_new)
					return
				end
			end)
		else
			return 1
		end
	end)
end

function DrawARound(team)
	GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1

	if TeamId2Hero(team).cloud_opp_name ~= nil then
		ShowCombat({
			t = 'battle_cloud_draw',
			player = TeamId2Hero(team):GetPlayerID(),
		})
	else
		ShowCombat({
			t = 'battle_pvp_draw',
			player = TeamId2Hero(team):GetPlayerID(),
			player2 = TeamId2Hero(GameRules:GetGameModeEntity().counterpart[team]):GetPlayerID(),
		})
	end

	EmitGlobalSound('crowd.lv_01')
	AddStat(TeamId2Hero(team):GetPlayerID(),'draw_round')
	RemoveLoseStreak(team)
	RemoveWinStreak(team)
end

function WinARound(team,mychess,my_last_chess)
	GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1

	--显示胜利！
	local alive_units = GameRules:GetGameModeEntity().to_be_destory_list[team]
	for _,unit in pairs(alive_units) do
		AddAbilityAndSetLevel(unit,'act_victory')
		unit.alreadywon = true
	end

	if TeamId2Hero(team).cloud_opp_name ~= nil then
		ShowCombat({
			t = 'battle_cloud_win',
			player = TeamId2Hero(team):GetPlayerID(),
			num = mychess,
		})
	else
		ShowCombat({
			t = 'battle_pvp_win',
			player = TeamId2Hero(team):GetPlayerID(),
			player2 = TeamId2Hero(GameRules:GetGameModeEntity().counterpart[team]):GetPlayerID(),
			num = mychess,
		})
	end

	EmitGlobalSound('crowd.lv_01')
	AddStat(TeamId2Hero(team):GetPlayerID(),'win_round')
	RemoveLoseStreak(team)
	AddWinStreak(team)

	if my_last_chess ~= nil then
		--发表胜利感言
		PlayChessDialogue(my_last_chess,'win')
	end

	local hero = TeamId2Hero(team)
	if hero.mirror_chesser ~= nil then
		hero.mirror_chesser:ForceKill(false)
		hero.mirror_chesser = nil
	end
	--得1金币
	AddMana(hero, 1)
	CustomGameEventManager:Send_ServerToTeam(team,"show_gold",{
		gold = hero:GetMana(),
		lose_streak = hero.lose_streak or 0,
		win_streak = hero.win_streak or 0,
	})
	
	--概率存阵容
	if RandomInt(1,100) < 5 then
		local lineup_table = {}
		for _,savechess in pairs(GameRules:GetGameModeEntity().mychess[team]) do
			table.insert(lineup_table,{
				x = savechess.x,
				y = savechess.y,
				lastitem = CopyTable(savechess.lastitem),
				chess = savechess.chess
			})
		end
		local obj = {
			owner = TeamId2Hero(team).steam_id,
			lineup = lineup_table,
			round = GameRules:GetGameModeEntity().battle_round - 1
		}
		table.insert(GameRules:GetGameModeEntity().upload_lineup,obj)
	end
end

function LoseARound(team,enemychess_new)
	GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1

	local hero = TeamId2Hero(team)
	local curr_hp = hero:GetHealth()
	local delay_time = 0
	local damage_all = 0

	--显示胜利！
	local n = GameRules:GetGameModeEntity().to_be_destory_list[team]

	for a,b in pairs(n) do
		AddAbilityAndSetLevel(b,'act_victory')
		b.alreadywon = true
		--主公掉血弹道
		local info =
	    {
	        Target = hero,
	        Source = b,
	        Ability = nil,
	        EffectName = "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
	        bDodgeable = false,
	        iMoveSpeed = 1000,
	        bProvidesVision = false,
	        iVisionRadius = 0,
	        iVisionTeamNumber = b:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    }
		projectile = ProjectileManager:CreateTrackingProjectile(info)

	    delay_time = (hero:GetAbsOrigin() - b:GetAbsOrigin()):Length2D() / 1000  --delay time取最后一个
	    damage_all = damage_all + math.floor(GetHitDamage(b) or 1)
	    AddStat(hero:GetPlayerID(),'deaths')
	end

	damage_all = damage_all
	local after_hp = curr_hp - damage_all
	if after_hp <= 0 then
		after_hp = 0
	end

	Timers:CreateTimer(delay_time,function()
		if after_hp <= 0 then
			hero:ForceKill(false)
			GameRules:GetGameModeEntity().counterpart[hero:GetTeam()] = -1
			SyncHP(hero)
			hero:SetMana(0)
			AMHC:CreateNumberEffect(hero,damage_all,2,AMHC.MSG_MISS,"red",9)
			ClearHand(hero:GetTeam())
			return
		end
		hero:SetHealth(after_hp)
		SyncHP(hero)
		AMHC:CreateNumberEffect(hero,damage_all,2,AMHC.MSG_MISS,"red",9)
		EmitSoundOn("Frostivus.PointScored.Enemy",hero)
	end)

	if TeamId2Hero(team).cloud_opp_name ~= nil then
		ShowCombat({
			t = 'battle_cloud_lose',
			player = TeamId2Hero(team):GetPlayerID(),
			num = enemychess_new,
		})
	else
		ShowCombat({
			t = 'battle_pvp_lose',
			player = TeamId2Hero(team):GetPlayerID(),
			player2 = TeamId2Hero(GameRules:GetGameModeEntity().counterpart[team]):GetPlayerID(),
			num = enemychess_new,
		})
	end
	
	EmitGlobalSound('crowd.lv_01')
	AddStat(TeamId2Hero(team):GetPlayerID(),'lose_round')
	AddLoseStreak(team)
	RemoveWinStreak(team)
end

function GetChessCountInBattleGround(m)
	local mychess_count = 0
	local enemychess_count = 0
	local my_last_chess = nil
	if GameRules:GetGameModeEntity().to_be_destory_list[m] ~= nil then
		for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[m]) do
			if q.team_id == m then
				mychess_count = mychess_count + 1
				my_last_chess = q
			else
				enemychess_count = enemychess_count + 1
			end
		end
	end

	return mychess_count,enemychess_count,my_last_chess
end

function GetHitDamage(u)
	local d = math.floor(1+(1.0*u:GetLevel()/3))
	return d
end
--游戏循环2——开始一轮战斗回合（包括回合结果判断）
function StartABattleRound()

	CustomNetTables:SetTableValue( "dac_table", "hide_damage_stat", 
		{ 
			hehe = RandomInt(1,100000) 
		} 
	)

	GameRules:SetTimeOfDay(0.3)
	
	GameRules:GetGameModeEntity().game_status = 2
	GameRules:GetGameModeEntity().battle_timer = 60

	

	if GameRules:GetGameModeEntity().battle_boss[GameRules:GetGameModeEntity().battle_round] ~= nil then
		-- prt(''..GameRules:GetGameModeEntity().battle_round..'PVE战斗回合开始')
		StartAPVERound()
	else
		-- prt(''..GameRules:GetGameModeEntity().battle_round..'PVP战斗回合开始')
		StartAPVPRound()
	end

	GameRules:GetGameModeEntity().battle_round = GameRules:GetGameModeEntity().battle_round + 1
	
	-- prt('next round: '..GameRules:GetGameModeEntity().battle_round)
end
--游戏循环2.1——分配对手
function AllocateABattleRound()
	local finished = false
	--local trytime = 0

	-- while finished == false and trytime < 10000 do
		--trytime = trytime + 1
		local alive_player_count = 0
		--统计玩家死活
		for u,v in pairs(GameRules:GetGameModeEntity().counterpart) do
			if TeamId2Hero(u) ~= nil and TeamId2Hero(u):IsNull() == false and TeamId2Hero(u):IsAlive() == true then
				--活玩家
				GameRules:GetGameModeEntity().counterpart[u] = u
				alive_player_count = alive_player_count +1
			else
				--死玩家
				GameRules:GetGameModeEntity().counterpart[u] = -1
			end
		end
		local rann = GameRules:GetGameModeEntity().lastrandomn
		if alive_player_count < 1 then
			return
		elseif alive_player_count == 1 then
			rann = 0
		elseif alive_player_count == 2 then
			rann = 1
		else
			while rann == GameRules:GetGameModeEntity().lastrandomn do
				rann = RandomInt(1,alive_player_count-1)
			end
		end
		GameRules:GetGameModeEntity().lastrandomn = rann
		--给活玩家分配一个随机对手
		for rotate_count = 1,rann do
			for i,j in pairs(GameRules:GetGameModeEntity().counterpart) do
				if j ~= -1 then
					local aliveteam = j
					
					local n = 1
					local try_count = 0
					while (aliveteam == j or GameRules:GetGameModeEntity().counterpart[aliveteam] == nil or GameRules:GetGameModeEntity().counterpart[aliveteam] == -1) and try_count<10000 do
						aliveteam = aliveteam + 1
						if aliveteam > 13 then
							aliveteam = 6
						end
						try_count = try_count + 1
					end
					GameRules:GetGameModeEntity().counterpart[i] = aliveteam
				end
			end
		end
	-- 	finished = CheckCounterpart()
	-- end
end
-- function FindNextAliveTeam(team)
-- 	local aliveteam = GameRules:GetGameModeEntity().counterpart[team]
-- 	local n = 1
-- 	local try_count = 0
-- 	while aliveteam == team or GameRules:GetGameModeEntity().counterpart[aliveteam] == -1 and try_count<10000 do
-- 		aliveteam = aliveteam + 1
-- 		if aliveteam > PlayerResource:GetPlayerCount() + 5 then
-- 			aliveteam = 6
-- 		end
-- 		try_count = try_count + 1
-- 	end
-- 	prt(''..team..'的下一个活着的敌人是'..aliveteam)
-- 	return aliveteam
-- end
-- function RotateTeams()
-- 	local rotate_str = ''
-- 	for i,j in pairs(GameRules:GetGameModeEntity().counterpart) do
-- 		if j ~= -1 then
-- 			local aliveteam = j
-- 			local n = 1
-- 			local try_count = 0
-- 			while aliveteam == team or GameRules:GetGameModeEntity().counterpart[aliveteam] == -1 and try_count<10000 do
-- 				aliveteam = aliveteam + 1
-- 				if aliveteam > PlayerResource:GetPlayerCount() + 5 then
-- 					aliveteam = 6
-- 				end
-- 				try_count = try_count + 1
-- 			end
-- 			prt(''..team..'的下一个活着的敌人是'..aliveteam)
-- 			GameRules:GetGameModeEntity().counterpart[i] = aliveteam
-- 			rotate_str = rotate_str..i..'对阵'..GameRules:GetGameModeEntity().counterpart[i]..','
-- 		end
-- 	end
-- 	prt(rotate_str)
-- end

--游戏循环2.1.x——分配对手用到的方法
function CheckCounterpart()
	local all_team_count = 0
	for _,__ in pairs(GameRules:GetGameModeEntity().counterpart) do
		all_team_count = all_team_count + 1
	end
	for team,conter in pairs(GameRules:GetGameModeEntity().counterpart) do
		if team == conter and all_team_count > 1 then
			return false
		end
	end
	return true
end
--为teamid的场地上所有的敌我棋子添加组合技还有vp北极熊的技能
function AddComboAbility(teamid)
	--通用技能
	local combo_chess_table_self = {}
	local combo_chess_table_enemy = {}
	local combo_count_table_self = {}
	local combo_count_table_enemy = {}
	--第一次循环：棋子分组
	for w,vw in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
		if vw.team_id == teamid then --我的棋子
			--比较和对手的血量
			local leading_team = teamid
			if GameRules:GetGameModeEntity().counterpart[teamid] ~= 0 and GameRules:GetGameModeEntity().stat_info[TeamId2Hero(teamid).steam_id]['hp'] < GameRules:GetGameModeEntity().stat_info[TeamId2Hero(GameRules:GetGameModeEntity().counterpart[teamid]).steam_id]['hp'] then
				leading_team = GameRules:GetGameModeEntity().counterpart[teamid]
			end
			if leading_team ~= vw.team_id and TeamId2Hero(vw.team_id) ~= nil and TeamId2Hero(vw.team_id):FindAbilityByName('h405_ability') ~= nil then
				AddAbilityAndSetLevel(vw,'h405_ability_inchess')
			end
			for k,vk in pairs(GameRules:GetGameModeEntity().combo_ability_type) do
				if combo_chess_table_self[k] == nil then
					combo_chess_table_self[k] = {}
				end
				if vw:FindAbilityByName(k) ~= nil or vw:FindAbilityByName(string.sub(k,1,-2)) ~= nil or vw:FindAbilityByName(string.sub(k,1,-3)) ~= nil then
					table.insert(combo_chess_table_self[k],vw)
				end
			end
		else --敌人的棋子
			--比较和对手的血量
			local leading_team = vw.at_team_id
			local opp = 0
			--找到被镜像的棋子对手是谁
			for teama,teamb in pairs(GameRules:GetGameModeEntity().counterpart) do
				if teamb == vw.at_team_id then
					opp = teama
				end
			end
			if opp ~= 0 and GameRules:GetGameModeEntity().stat_info[TeamId2Hero(vw.at_team_id).steam_id]['hp'] < GameRules:GetGameModeEntity().stat_info[TeamId2Hero(opp).steam_id]['hp'] then
				leading_team = opp
			end
			if leading_team == teamid and TeamId2Hero(vw.at_team_id) ~= nil and TeamId2Hero(vw.at_team_id):FindAbilityByName('h405_ability') ~= nil then
				AddAbilityAndSetLevel(vw,'h405_ability_inchess')
			end
			for k,vk in pairs(GameRules:GetGameModeEntity().combo_ability_type) do
				if combo_chess_table_enemy[k] == nil then
					combo_chess_table_enemy[k] = {}
				end
				if vw:FindAbilityByName(k) ~= nil or vw:FindAbilityByName(string.sub(k,1,-2)) ~= nil or vw:FindAbilityByName(string.sub(k,1,-3)) ~= nil then
					table.insert(combo_chess_table_enemy[k],vw)
				end
			end
		end
	end
	--第二次循环：计数
	for k,vk in pairs(combo_chess_table_self) do
		--统计不同的种类数
		local diff_count = 0
		local diff_string = ''
		for _,chess in pairs(combo_chess_table_self[k]) do
			--去掉等级变量
			local find_name = chess:GetUnitName()
			if string.find(find_name,'11') ~= nil then
				find_name = string.sub(find_name,1,-3)
			end
			if string.find(find_name,'1') ~= nil then
				find_name = string.sub(find_name,1,-2)
			end
			--搜索是否重复了
			if string.find(diff_string,find_name) == nil then
				diff_count = diff_count + 1
				diff_string = diff_string..'-'..find_name
			end
		end
		if TeamId2Hero(teamid):FindAbilityByName(k) ~= nil then
			diff_count = diff_count + 1
		end
		combo_count_table_self[k] = diff_count
	end
	for k,vk in pairs(combo_chess_table_enemy) do
		--统计不同的种类数
		local diff_count = 0
		local diff_string = ''
		for _,chess in pairs(combo_chess_table_enemy[k]) do
			--去掉等级变量
			local find_name = chess:GetUnitName()
			if string.find(find_name,'11') ~= nil then
				find_name = string.sub(find_name,1,-3)
			end
			if string.find(find_name,'1') ~= nil then
				find_name = string.sub(find_name,1,-2)
			end
			--搜索是否重复了
			if string.find(diff_string,find_name) == nil then
				diff_count = diff_count + 1
				diff_string = diff_string..'-'..find_name
			end
		end
		combo_count_table_enemy[k] = diff_count
	end
	--第三次循环：添加技能
	for p,vp in pairs(combo_chess_table_self) do
		local shaman_gua = false
		local type1 = GameRules:GetGameModeEntity().combo_ability_type[p]['type']
		local condition = GameRules:GetGameModeEntity().combo_ability_type[p]['condition']
		local buff_ability = GameRules:GetGameModeEntity().combo_ability_type[p]['ability']

		if condition == 0 then
			if combo_count_table_self[p] == 1 and combo_count_table_enemy['is_demonhunter'] == 0 then
				for _,chess in pairs(vp) do
					if buff_ability ~= nil then
						AddAbilityAndSetLevel(chess,buff_ability)
					end
				end
			end
			if combo_count_table_self['is_demonhunter'] == 2 then
				for _,chess in pairs(vp) do
					if buff_ability ~= nil then
						AddAbilityAndSetLevel(chess,buff_ability)
					end
				end
			end
		else
			if combo_count_table_self[p] >= condition then
				for _,chess in pairs(combo_chess_table_self[p]) do
					if p == 'is_shaman' and shaman_gua == false then
						shaman_gua = true
						AddAbilityAndSetLevel(chess,'frog_voodoo')
					end
					if p == 'is_dragon' then
						play_particle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions_ring_dragon.vpcf",PATTACH_OVERHEAD_FOLLOW,chess,5)
						EmitSoundOn('Hero_DragonKnight.DragonTail.Target',chess)
						chess.is_dragon_zhanhou = true
						chess:SetMana(100)
					end
				end
				--同类有技能
				if type1 == 1 then
					for _,chess in pairs(combo_chess_table_self[p]) do
						if buff_ability ~= nil then
							AddAbilityAndSetLevel(chess,buff_ability)
						end
					end
				end
				--友军有技能
				if type1 == 2 then
					for _,chess in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
						--是友军
						if chess.team_id == teamid then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
								end
							end
						end
					end
				end
				--敌军有技能
				if type1 == 3 then
					for _,chess in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
						--是敌军
						if chess.team_id == 4 then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
								end
							end
						end
					end
				end
				--随机一个友军有技能
				if type1 == 4 then
					local try_count = 0
					local is_ok = false
					while is_ok == false and try_count < 100 do
						local r = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list[teamid]))
						local chess = GameRules:GetGameModeEntity().to_be_destory_list[teamid][r]
						if chess.team_id == teamid then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
									is_ok = true
								end
							end
						end
						try_count = try_count + 1
					end
				end
			end
		end
	end
	for p,vp in pairs(combo_chess_table_enemy) do
		local shaman_guagua = false
		local type1 = GameRules:GetGameModeEntity().combo_ability_type[p]['type']
		local condition = GameRules:GetGameModeEntity().combo_ability_type[p]['condition']
		local buff_ability = GameRules:GetGameModeEntity().combo_ability_type[p]['ability']
		if condition == 0 then
			if combo_count_table_enemy[p] == 1 and combo_count_table_self['is_demonhunter'] == 0 then
				for _,chess in pairs(vp) do
					if buff_ability ~= nil then
						AddAbilityAndSetLevel(chess,buff_ability)
					end
				end
			end
			if combo_count_table_enemy['is_demonhunter'] == 2 then
				for _,chess in pairs(vp) do
					if buff_ability ~= nil then
						AddAbilityAndSetLevel(chess,buff_ability)
					end
				end
			end
		else
			if combo_count_table_enemy[p] >= condition then
				for _,chess in pairs(combo_chess_table_enemy[p]) do
					if p == 'is_shaman' and shaman_guagua == false then
						AddAbilityAndSetLevel(chess,'frog_voodoo')
						shaman_guagua = true
					end
					if p == 'is_dragon' then
						play_particle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions_ring_dragon.vpcf",PATTACH_OVERHEAD_FOLLOW,chess,5)
						EmitSoundOn('Hero_DragonKnight.DragonTail.Target',chess)
						chess.is_dragon_zhanhou = true
						chess:SetMana(100)
					end
				end
				--同类有技能
				if type1 == 1 then
					for _,chess in pairs(combo_chess_table_enemy[p]) do
						if buff_ability ~= nil then
							AddAbilityAndSetLevel(chess,buff_ability)
						end
					end
				end
				--友军有技能
				if type1 == 2 then
					for _,chess in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
						if chess.team_id == 4 then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
								end
							end
						end
					end
				end
				--敌军有技能
				if type1 == 3 then
					for _,chess in pairs(GameRules:GetGameModeEntity().to_be_destory_list[teamid]) do
						--是敌军
						if chess.team_id == teamid then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
								end
							end
						end
					end
				end
				--随机一个友军有技能
				if type1 == 4 then
					local try_count = 0
					local is_ok = false
					while is_ok == false and try_count < 100 do
						local r = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list[teamid]))
						local chess = GameRules:GetGameModeEntity().to_be_destory_list[teamid][r]
						if chess.team_id == 4 then
							if string.find(chess:GetUnitName(),'hero') == nil then
								if buff_ability ~= nil then
									AddAbilityAndSetLevel(chess,buff_ability)
									is_ok = true
								end
							end
						end
						try_count = try_count + 1
					end
				end
			end
		end
	end
end
--游戏循环2.2——镜像要打的敌人和给他们加组合技
function MirrorARound(teamid)
	local opp = nil
	local my_opp = nil

	Timers:CreateTimer(RandomFloat(0.1,0.5),function()
		-- DeepPrintTable(GameRules:GetGameModeEntity().counterpart)
		for myteam,enemyteam in pairs(GameRules:GetGameModeEntity().counterpart) do
			if enemyteam == teamid then
				opp = myteam
			end
			if myteam == teamid then
				my_opp = enemyteam
			end
		end
		if opp ~= nil then
			--镜像棋手
			Timers:CreateTimer(1,function()
				local opp_hero = TeamId2Hero(my_opp)
				local opp_steam_id = opp_hero.steam_id
				local opp_model = GameRules:GetGameModeEntity().stat_info[opp_steam_id]['zhugong_model']
				local opp_effect = GameRules:GetGameModeEntity().stat_info[opp_steam_id]['zhugong_effect']
				MirrorChesser(teamid,opp_model,opp_effect,opp_hero:GetModelScale())
			end)

			for i=1,4 do
				for j=1,8 do
					if GameRules:GetGameModeEntity().mychess[teamid][i..'_'..j] ~= nil then
						GameRules:GetGameModeEntity().unit[teamid][i..'_'..j] = 1
						GameRules:GetGameModeEntity().unit[opp][(9-i)..'_'..(9-j)] = 1
						--复制棋子
						MirrorAChess(teamid,i,j,opp)
					end
				end
			end
			Timers:CreateTimer(1,function()
				AddComboAbility(teamid)
			end)
		end
	end)
end

function MirrorAChess(teamid,i,j,opp)
	Timers:CreateTimer(RandomFloat(0.1,0.5),function()
		local x = CreateUnitByName(GameRules:GetGameModeEntity().mychess[teamid][i..'_'..j].chess,XY2Vector(9-j,9-i,opp),true,nil,nil,DOTA_TEAM_NEUTRALS)
		MakeTiny(x)
		x:SetForwardVector(Vector(0,-1,0))

		x.y_x = (9-i)..'_'..(9-j)
		x.y = 9-i
		x.x = 9-j

		x.team_id = 4
		x.at_team_id = opp
		AddAbilityAndSetLevel(x,'root_self')
		AddAbilityAndSetLevel(x,'jiaoxie_wudi')
		table.insert(GameRules:GetGameModeEntity().to_be_destory_list[opp],x)

		--复制物品
		local uindex = GameRules:GetGameModeEntity().mychess[teamid][i..'_'..j].index
		for slot=0,8 do
			if EntIndexToHScript(uindex):GetItemInSlot(slot)~= nil then
				local name = EntIndexToHScript(uindex):GetItemInSlot(slot):GetAbilityName()
				if name ~= nil then
					x:AddItemByName(name)
				end
			end
		end
	end)
end

--为teamid场地镜像my_opp队伍的敌人棋手镜像
function MirrorChesser(teamid,opp_model,opp_effect,model_scale)
	local mirror_chesser_position = Entities:FindByName(nil,"center"..(teamid-6)):GetAbsOrigin()
	local mirror_chesser = CreateUnitByName("player_image",mirror_chesser_position+Vector(0,128*6.5,256),true,nil,nil,DOTA_TEAM_NEUTRALS)
	mirror_chesser:SetForwardVector(Vector(0,-1,0))
	if model_scale == nil then
		model_scale = 1
	end
	mirror_chesser:SetModelScale(model_scale)
	TeamId2Hero(teamid).mirror_chesser = mirror_chesser
	--镜像棋手形象
	if opp_model ~= nil then
		local new_m = ChangeFlyingCourierModel(opp_model)

		mirror_chesser:SetOriginalModel(new_m)
		mirror_chesser:SetModel(new_m)
		AddAbilityAndSetLevel(mirror_chesser,'courier_fly')
	end

	if opp_effect ~= nil and opp_effect ~= 'e000' then
		AddAbilityAndSetLevel(mirror_chesser,opp_effect)
	end
end

function LoadCloudEnemy(wave,team)
	if GameRules:GetGameModeEntity().cloudlineup[''..wave] ~= nil then
		local chesses = nil
		for _,data in pairs(GameRules:GetGameModeEntity().cloudlineup[''..GameRules:GetGameModeEntity().battle_round]) do
			chesses = json.decode(data)
		end

		--镜像棋手
		if chesses['zhugong'] ~= nil then
			local cloud_hero = string.split(chesses['zhugong'],'_')[1]
			local cloud_hero_effect = string.split(chesses['zhugong'],'_')[2] or ''

			local opp_model = GameRules:GetGameModeEntity().sm_hero_list[cloud_hero]

			Timers:CreateTimer(1,function()
				MirrorChesser(team,opp_model,cloud_hero_effect,(GameRules:GetGameModeEntity().sm_hero_size[cloud_hero] or 1))
			end)
		end

		if chesses ~= nil then
			for i,vi in pairs(chesses.lineup) do
				GameRules:GetGameModeEntity().unit[team][(9-vi.y)..'_'..(9-vi.x)] = 1
				local x = CreateUnitByName(vi.chess,XY2Vector((9-vi.x),(9-vi.y),team),true,nil,nil,DOTA_TEAM_NEUTRALS)
				x:SetForwardVector(Vector(0,-1,0))
				x.y_x = (9-vi.y)..'_'..(9-vi.x)
				x.y = (9-vi.y)
				x.x = (9-vi.x)
				x.team_id = 4
				x.at_team_id = team
				AddAbilityAndSetLevel(x,'root_self')
				AddAbilityAndSetLevel(x,'jiaoxie_wudi')
				table.insert(GameRules:GetGameModeEntity().to_be_destory_list[team],x)
				--复制物品
				if vi.lastitem ~= nil then
					for _,it in pairs(vi.lastitem) do
						x:AddItemByName(it)
					end
				end
			end
		end
	end
	Timers:CreateTimer(0.5,function()
		AddComboAbility(team)
	end)
end
--游戏循环2.3——自走！
function ChessAI(u)
	if u.aitimer == nil or Timers.timers[u.aitimer] == nil then
		if u:GetUnitName() == 'chess_sf' then
			AddAbilityAndSetLevel(u,"nevermore_necromastery")		
			u:FindModifierByName("modifier_nevermore_necromastery"):SetStackCount(12)
		end
		if u:GetUnitName() == 'chess_sf1' then
			AddAbilityAndSetLevel(u,"nevermore_necromastery")			
			u:FindModifierByName("modifier_nevermore_necromastery"):SetStackCount(16)
		end
		if u:GetUnitName() == 'chess_sf11' then
			AddAbilityAndSetLevel(u,"nevermore_necromastery")		
			u:FindModifierByName("modifier_nevermore_necromastery"):SetStackCount(20)
		end
		RemoveAbilityAndModifier(u,'jiaoxie_wudi')

		u.aitimer = Timers:CreateTimer(RandomFloat(0.5,2),function()
			--容错
			if u:FindAbilityByName('modifier_no_hp_bar') ~= nil or u:FindAbilityByName('modifier_jiaoxie_wudi') ~= nil then
				u:Destroy()
				return
			end

			if u == nil or u:IsNull() == true or u:IsAlive() == false or u.alreadywon == true then
				return
			end

			local ai_delay = 0
			if u:FindModifierByName('modifier_batrider_sticky_napalm') ~= nil then
				ai_delay = u:FindModifierByName('modifier_batrider_sticky_napalm'):GetStackCount()
			end

			if u:IsStunned() == true then
				return 1
			end


			--使用物品
			local refresh_result = TriggerRefreshOrb(u)
			if refresh_result ~= nil and refresh_result > 0 then
				return refresh_result + ai_delay
			end

			local tiaodao_result = TriggerTiaodao(u)
			if tiaodao_result ~= nil and tiaodao_result > 0 then
				return tiaodao_result + ai_delay
			end

			local sheep_result = TriggerSheepStick(u)
			if sheep_result ~= nil and sheep_result > 0 then
				return sheep_result + ai_delay
			end

			local dagon_result = TriggerDagon(u)
			if dagon_result ~= nil and dagon_result > 0 then
				return dagon_result + ai_delay
			end

			local gua_result = TriggerFrogGua(u)
			if gua_result ~= nil and gua_result > 0 then
				return gua_result + ai_delay
			end

			
			--释放技能：11=新沙王，0=被动技能，1=单位目标，2=无目标，3=点目标，4=自己目标，5=近身单位目标，6=先知在地图边缘招树人，7=随机友军目标（嗜血术），8=随机周围空地目标（炸弹人），9=血量百分比最低的队友，10=等级最高的敌人（末日），11=沙王戳最远的能打到敌人的格子，12=小小投掷身边的敌人到最远的格子
			local a = GameRules:GetGameModeEntity().chess_ability_list[u:GetUnitName()]
			--决定是否要放技能
			if a ~= nil and u:FindModifierByName('modifier_doom_bringer_doom') == nil and u:FindModifierByName('modifier_hexxed') == nil and u:FindModifierByName('modifier_shadow_shaman_voodoo') == nil and u:FindModifierByName('modifier_medusa_stone_gaze_stone') == nil and u:IsSilenced() == false then
				if u:GetMana() >= 100 and GameRules:GetGameModeEntity().ability_behavior_list[a] ~= 0 and u:FindAbilityByName(a):IsCooldownReady() == true then
					--有蓝，释放技能
					if GameRules:GetGameModeEntity().ability_behavior_list[a] == 1 then
						--单位目标
						local unluckydog = FindUnluckyDog(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 2 then
						--无目标
						local newOrder = {
					 		UnitIndex = u:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					 		TargetIndex = nil, --Optional.  Only used when targeting units
					 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
					 		Position = nil, --Optional.  Only used when targeting the ground
					 		Queue = 0 --Optional.  Used for queueing up abilities
					 	}
						ExecuteOrderFromTable(newOrder)
						return RandomFloat(0.5,2) + ai_delay
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 4 then
						--单位目标
						local unluckydog = u
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 5 then
						--近身单位目标
						local unluckydog = FindUnluckyDog190(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 6 then
						--棋盘边缘的空格点目标，先知用
						local unluckypoint = FindUnluckyPoint(u)
						if unluckypoint ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil, --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = unluckypoint, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 7 then
						--随机友军单位目标
						local unluckydog = FindUnluckyDogRandomFriend(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 8 then
						--点目标，随机一个空格子
						local unluckypoint = FindEmptyGridAtUnit(u)--FindRandomEmptyGrid(u)
						if unluckypoint ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil, --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = unluckypoint, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 9 then
						--随机友军单位目标
						local unluckydog = FindNeedHealFriend(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 10 then
						--等级最高的敌方单位目标
						local unluckydog = FindHighLevelUnluckyDog(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = nil, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)
							return RandomFloat(0.5,2) + ai_delay
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 11 then
						
						local unluckypoint = FindFarthestCanAttackEnemyEmptyGrid(u)
						if unluckypoint ~= nil then

							--先占领目标格子
							local target_x = Vector2X(unluckypoint,u.at_team_id or u.team_id)
							local target_y = Vector2Y(unluckypoint,u.at_team_id or u.team_id)
							GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][target_y..'_'..target_x] = 1
							GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][u.y_x] = nil
							u.y_x = target_y..'_'..target_x
							u.y = target_y
							u.x = target_x

							--穿刺/波浪 过去！
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil, --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = unluckypoint, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)

							local go_duration = (unluckypoint - u:GetAbsOrigin()):Length2D() / 1500

							return RandomFloat(0.5,1) + go_duration + ai_delay
						else
							return RandomFloat(0.5,1)
						end
					elseif GameRules:GetGameModeEntity().ability_behavior_list[a] == 12 then
						
						local unluckypoint = FindFarthestEmptyGrid(u)
						if unluckypoint ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil,--unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = unluckypoint, --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)

							return RandomFloat(0.5,2) + ai_delay
						end
					else
						--点目标
						local unluckydog = FindUnluckyDog(u)
						if unluckydog ~= nil then
							local newOrder = {
						 		UnitIndex = u:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						 		TargetIndex = nil,--unluckydog:entindex(), --Optional.  Only used when targeting units
						 		AbilityIndex = u:FindAbilityByName(a):entindex(), --Optional.  Only used when casting abilities
						 		Position = unluckydog:GetAbsOrigin(), --Optional.  Only used when targeting the ground
						 		Queue = 0 --Optional.  Used for queueing up abilities
						 	}
							ExecuteOrderFromTable(newOrder)

							--光法 风行 蓄力
							if a=="keeper_of_the_light_illuminate" or a=="windrunner_powershot" then
								return 3.5 + ai_delay
							else
								return RandomFloat(0.5,2) + ai_delay
							end
						end
					end
				end
			end

			--决定是否要攻击
			local attack_result = FindAClosestEnemyAndAttack(u)
			if attack_result ~= nil and attack_result > 0 then
				return attack_result + ai_delay
			end

			--不攻击就走动
			if u.attack_target == nil then

				local find_ok = nil
				local try_count = 0

				--寻路
				if u:FindAbilityByName('is_assassin') ~= nil then
					find_ok = FindFarthestUnluckyDogAvailablePosition(u)
				else
					find_ok = FindNextSkipPosition(u)
				end

				if find_ok ~= nil then
					--走！
					local x = Vector2X(find_ok,u.at_team_id or u.team_id)
					local y = Vector2Y(find_ok,u.at_team_id or u.team_id)
					local xx = u.x
					local yy = u.y
					GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][y..'_'..x] = 1
					u:SetForwardVector((find_ok - u:GetAbsOrigin()):Normalized())
					BlinkChessX({p=find_ok,caster=u})
					u.y_x = y..'_'..x
					u.y = y
					u.x = x
					GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][yy..'_'..xx] = nil

					--计算需要跳多久
					local jump_time = (find_ok - u:GetAbsOrigin()):Length2D() / 1000

					return RandomFloat(jump_time+0.5,jump_time+1) + ai_delay

				end
				return RandomFloat(0.5,1) + ai_delay
			else
				return 1 + ai_delay
			end
			-- end
			return 1 + ai_delay
		end)
	end
end
--寻找离我最近的能攻击到指定敌人的空格子
function FindClosestEmptyGridToAttackUnluckydog(u,dog)
	local team = u.at_team_id or u.team_id
	local attack_range = u:Script_GetAttackRange() or 210
	local closest_range = 9999
	local closet_position = nil
	-- prt('dog.x/dog.y='..dog.x..'/'..dog.y)
	local dog_position = XY2Vector(dog.x,dog.y,team)
	for x=1,8 do
		for y=1,8 do
			local pos = XY2Vector(x,y,team)
			if (pos-dog_position):Length2D() < attack_range - dog:GetHullRadius() then 
				--能攻击到dog
				local range = (pos - XY2Vector(u.x,u.y,team)):Length2D()
				if IsEmptyGrid(team,x,y) == true and range < closest_range then 
					--离我最近的空格子
					closest_range = range
					closet_position = pos
				end
			end
		end
	end

	local pos = FindPath(XY2Vector(u.x,u.y,team),closet_position,team)

	return pos
end
--寻找我的下一跳位置
function FindNextSkipPosition(u)
	local team_id = u.at_team_id or u.team_id
	local skip_postion = nil
	local length2d = 99999
	local pos1 = XY2Vector(u.x,u.y,team_id)
	for x=1,8 do
		for y=1,8 do
			local pos2 = XY2Vector(x,y,team_id)
			if IsGridCanAttackEnemy(x,y,u) == true then
				local next_skip = IsGridCanReach(x,y,u)
				if next_skip ~= nil and (pos2-pos1):Length2D() < length2d then
					skip_postion = next_skip
					length2d = (pos2-pos1):Length2D()
				end
			end
		end
	end
	return skip_postion
end
function IsGridCanAttackEnemy(x,y,u)
	local team_id = u.at_team_id or u.team_id
	local attack_range = u:Script_GetAttackRange() or 210
	--遍历所有单位
	for _,enemy in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
		if enemy.team_id ~= u.team_id and enemy:IsInvisible() == false and (XY2Vector(x,y,team_id) - enemy:GetAbsOrigin()):Length2D() < attack_range - enemy:GetHullRadius() then
			return true
		end
	end
	return false
end
function IsGridCanReach(x,y,u)
	local team_id = u.at_team_id or u.team_id
	local pos1 = XY2Vector(u.x,u.y,team_id)
	local pos2 = XY2Vector(x,y,team_id)
	local pos = FindPath(pos1,pos2,team_id)
	if pos ~= nil then
		return pos
	else
		return nil
	end
end


function IsEmptyGrid(team,x,y)
	if GameRules:GetGameModeEntity().unit[team][y..'_'..x] == nil then
		return true
	else
		return false
	end
end

function FindCurrColFarthestCanAttackPosition(u)
	local team_id = u.at_team_id or u.team_id
	local y = u.y
	local i = u.x
	if u.team_id ~= 4 then
		for j=8,1,-1 do
			if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
				for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
					if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() and j>y then
						return XY2Vector(i,j,team_id)
					end
				end
			end
		end
	else
		for j=1,8 do
			if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
				for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
					if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() and j<y then
						return XY2Vector(i,j,team_id)
					end
				end
			end
		end
	end
end

function FindFarthestUnluckyDogAvailablePosition(u)
	local team_id = u.at_team_id or u.team_id
	if u.team_id ~= 4 then
		if RandomInt(0,100) > 50 then
			for j=8,1,-1 do
				for i=8,1,-1 do
					if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
						for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
							if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() then
								return XY2Vector(i,j,team_id)
							end
						end
					end
				end
			end
		else
			for j=8,1,-1 do
				for i=1,8 do
					if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
						for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
							if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() then
								return XY2Vector(i,j,team_id)
							end
						end
					end
				end
			end
		end
	else
		if RandomInt(0,100) > 50 then
			for j=1,8 do
				for i=1,8 do
					if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
						for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
							if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() then
								return XY2Vector(i,j,team_id)
							end
						end
					end
				end
			end
		else
			for j=1,8 do
				for i=8,1,-1 do
					if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
						for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
							if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < u:Script_GetAttackRange() - unit:GetHullRadius() then
								return XY2Vector(i,j,team_id)
							end
						end
					end
				end
			end
		end
	end
	return nil
end
function FindClosestUnluckyDogAvailablePosition(u)
	local team_id = u.at_team_id or u.team_id
	if u.team_id == 4 then
		for j=8,1,-1 do
			for i=8,1,-1 do
				if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
					for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
						if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < 192 then
							return XY2Vector(i,j,team_id)
						end
					end
				end
			end
		end
	else
		for j=1,8 do
			for i=1,8 do
				if GameRules:GetGameModeEntity().unit[team_id][j..'_'..i] == nil then
					for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
						if unit.team_id ~= u.team_id and (XY2Vector(i,j,team_id) - XY2Vector(unit.x,unit.y,team_id)):Length2D() < 192 then
							return XY2Vector(i,j,team_id)
						end
					end
				end
			end
		end
	end

	return nil
end

function FindEmptyGridAtUnit(u)
	local team_id = u.at_team_id or u.team_id

	--优先选取面前的空格子
	local forward_v  = u:GetAbsOrigin() + u:GetForwardVector():Normalized()*128
	local forward_x = Vector2X(forward_v,team_id)
	local forward_y = Vector2Y(forward_v,team_id)
	if IsIn8x8(forward_x,forward_y) == true and IsEmptyGrid(team_id,forward_x,forward_y) == true then
		debug('FindEmptyGridAtUnit选中x='..forward_x..',y='..forward_y)
		return XY2Vector(forward_x,forward_y,team_id)
	end

	--遍历身边的格子
	for x = -1,1 do
		for y = -1,1 do
			if IsIn8x8(u.x+x,u.y+y) == true and IsEmptyGrid(team_id,u.x+x,u.y+y) == true then
				debug('FindEmptyGridAtUnit选中x='..(u.x+x)..',y='..(u.y+y))
				return XY2Vector(u.x+x,u.y+y,team_id)
			end
		end
	end

	for xx = -2,2 do
		for yy = -2,2 do
			if IsIn8x8(u.x+xx,u.y+yy) == true and IsEmptyGrid(team_id,u.x+xx,u.y+yy) == true then
				debug('FindEmptyGridAtUnit选中x='..(u.xx+x)..',y='..(u.y+yy))
				return XY2Vector(u.x+xx,u.y+yy,team_id)
			end
		end
	end

	return nil
end

--通用方法之寻找一个倒霉蛋
function FindUnluckyDog(u)
	local unluckydog = nil
	local try_count = 0
	while unluckydog == nil and try_count < 10 do
		local uu = GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id][RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]))]
		if uu ~= nil and uu:IsNull() == false and uu:IsAlive() == true and uu.team_id ~= u.team_id then
			unluckydog = uu
		end
		try_count = try_count + 1
	end
	return unluckydog
end
function FindHighLevelUnluckyDog(u)
	local unluckydog = nil
	local max_level = 0
	local team = u.at_team_id or u.team_id
	local my_pos = XY2Vector(u.x,u.y,team)

	if RandomInt(1,100)<30 then
		--30%概率随机找敌人
		return FindUnluckyDogRandom(u)
	end

	for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]) do
		local lv = unit:GetLevel()
		if unit:GetMaxMana() <= 0 then
			lv = 1
		end
		local a = GameRules:GetGameModeEntity().chess_ability_list[unit:GetUnitName()]
		local beh = GameRules:GetGameModeEntity().ability_behavior_list[a]

		if lv > max_level and unit.team_id ~= u.team_id and unit:FindModifierByName("modifier_doom_bringer_doom") == nil and beh ~= 0 then
			unluckydog = unit
			max_level = lv
		end
	end
	return unluckydog
end
function FindUnluckyDogRandom(u)
	local unluckydog = nil
	local team = u.at_team_id or u.team_id
	local my_pos = XY2Vector(u.x,u.y,team)
	local try_count = 0 

	while unluckydog == nil and try_count < 10000 do
		local random = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list))
		local unit = GameRules:GetGameModeEntity().to_be_destory_list[random]
		if unit.team_id ~= u.team_id and unit:IsInvisible() == false then
			unluckydog = unit
		end
		try_count = try_count + 1
	end

	return unluckydog
end
function FindUnluckyDogClosest(u)
	local unluckydog = nil
	local length2d = 99999
	local team = u.at_team_id or u.team_id
	local my_pos = XY2Vector(u.x,u.y,team)
	for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]) do
		local pos = unit:GetAbsOrigin()
		if (my_pos - pos):Length2D() < length2d and unit.team_id ~= u.team_id and unit:IsInvisible() == false then
			unluckydog = unit
			length2d = (my_pos - pos):Length2D() 
		end
	end
	return unluckydog
end
function FindUnluckyDogFarthest(u)
	local unluckydog = nil
	local length2d = 0
	for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]) do
		if (u:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() > length2d and unit.team_id ~= u.team_id then
			unluckydog = unit
			length2d = (u:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() 
		end
	end
	return unluckydog
end
function FindUnluckyDog190(u)
	local unluckydog = nil
	local try_count = 0
	while unluckydog == nil and try_count < 10 do
		local uu = GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id][RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]))]
		if uu ~= nil and uu:IsNull() == false and uu:IsAlive() == true and uu.team_id ~= u.team_id and (uu:GetAbsOrigin()-u:GetAbsOrigin()):Length2D() <= 205 then
			unluckydog = uu
		end
		try_count = try_count + 1
	end
	return unluckydog
end
function FindUnluckyDogRandomFriend(u)
	local unluckydog = nil
	local try_count = 0
	while unluckydog == nil and try_count < 30 do
		local uu = GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id][RandomInt(1,table.maxn(GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]))]
		if uu ~= nil and uu:IsNull() == false and uu:IsAlive() == true and uu.team_id == u.team_id and uu:FindModifierByName("modifier_ogre_magi_bloodlust") == nil then
			unluckydog = uu
		end
		try_count = try_count + 1
	end
	return unluckydog
end
function FindNeedHealFriend(u)
	local unluckydog = u
	local hp_per = 100
	for _,unit in pairs (GameRules:GetGameModeEntity().to_be_destory_list[u.at_team_id or u.team_id]) do
		if unit.team_id == u.team_id then
			local hp = unit:GetHealth()
			local hp_max = unit:GetMaxHealth()
			local per = 1.0*hp/hp_max*100

			if per < hp_per then
				unluckydog = unit
				hp_per = per
			end
		end
	end
	return unluckydog
end

--沙王用：寻找一个最远的能打到敌人的离我最远的格子，（戳过去！）
function FindFarthestCanAttackEnemyEmptyGrid(u)
	local team_id = u.at_team_id or u.team_id
	local length2d = 0
	local pos1 = u:GetAbsOrigin()
	local skip_postion = nil

	for x=1,8 do
		for y=1,8 do
			local pos2 = XY2Vector(x,y,team_id)
			if IsEmptyGrid(team_id,x,y) and IsGridCanAttackEnemy(x,y,u) == true then
				if (pos2-pos1):Length2D() > length2d then
					skip_postion = pos2
					length2d = (pos2-pos1):Length2D()
				end
			end
		end
	end

	return skip_postion
end

function FindUnluckyPoint(u)
	local p = nil
	local try_count = 0
	local team_id = u.at_team_id or u.team_id
	local x = nil
	local y = nil
	while p==nil and try_count<100 do
		if RandomInt(0,100)>50 then
			if RandomInt(0,100)>50 then
				x = 1
				y = RandomInt(1,8)
			else
				x = 8
				y = RandomInt(1,8)
			end
		else
			if RandomInt(0,100)>50 then
				y = 1
				x = RandomInt(1,8)
			else
				y = 8
				x = RandomInt(1,8)
			end
		end
		if GameRules:GetGameModeEntity().unit[team_id][y..'_'..x] == nil then
			if (XY2Vector(x,y,team_id) - u:GetAbsOrigin()):Length2D() > 256 then
				p = XY2Vector(x,y,team_id)
			end
		end

		try_count = try_count + 1
	end
	return p
end

function FindRandomEmptyGrid(u)
	local p = nil
	local try_count = 0
	local team_id = u.at_team_id or u.team_id
	local x = nil
	local y = nil
	while p==nil and try_count<100 do
		x = RandomInt(1,8)
		y = RandomInt(1,8)
		if GameRules:GetGameModeEntity().unit[team_id][y..'_'..x] == nil then
			if (XY2Vector(x,y,team_id) - u:GetAbsOrigin()):Length2D() < 200 then
				p = XY2Vector(x,y,team_id)
			end
		end
		try_count = try_count + 1
	end
	return p
end

--通用方法之坐标系转换
function HandIndex2Vector(team_id,index)
	return GameRules:GetGameModeEntity().base_vector[team_id] + Vector((index-1)*128,-2*128,256)
end
function CheckTargetPosInHand(p,team_id)
	if Vector2X(p,team_id) >= 1 and Vector2X(p,team_id) <= 8 and Vector2Y(p,team_id) == -1 and CheckEmptyHandSlot(team_id,Vector2X(p,team_id)) == true then
		return Vector2X(p,team_id)
	else
		return false
	end
end
function XY2Vector(x,y,team_id)
	return GameRules:GetGameModeEntity().base_vector[team_id] + Vector((x-1)*128,(y-1)*128,256)
end
function Vector2X(v,team_id)
	local relative_position = v - GameRules:GetGameModeEntity().base_vector[team_id]
	local x = math.floor((relative_position.x+192)/128)
	-- if x < 1 or x > 8 then
	-- 	x = -1
	-- end
	return x
end
function Vector2Y(v,team_id)
	local relative_position = v - GameRules:GetGameModeEntity().base_vector[team_id]
	local y = math.floor((relative_position.y+192)/128)
	-- if y < 1 or y > 8 then
	-- 	y = -1
	-- end
	return y
end
function CenterVector(team_id)
	return GameRules:GetGameModeEntity().base_vector[team_id] + Vector(3.5*128,2.5*128,0)
end
--通用方法之位置判断
function IsInMap(x,y)
	--格子是否在防守场地
	if x<1 or x>8 or y<1 or y>4 then
		return false
	else
		return true
	end
end
function IsInDefendArea(x,y)
	if x>=1 and x<=8 and y>=1 and y<=4 then
		return true
	else
		return false
	end
end
function IsInAttackArea(x,y)
	--格子是否在进攻场地
	if x>=1 and x<=8 and y>=5 and y<=8 then
		return true
	else
		return false
	end
end
function IsIn8x8(x,y)
	if x>=1 and x<=8 and y>=1 and y<=8 then
		return true
	else
		return false
	end
end
function GetClosestAvailableArea(x,y,team_id)
	local returnx = x
	local returny = y
	if y>4 then
		returny = 4
	elseif y<1 then
		returny = 1
	end
	if x>8 then
		returnx = 8
	elseif x<1 then
		returnx = 1
	end
	return {x = returnx, y =returny}
end
function GetClosestEmptyArea(x,y,team_id)
	for i=-1,1 do
		for j=-1,1 do
			if IsBlocked(x+i,y+j,team_id) == false then
				return {x = x+i, y = y+j}
			end
		end
	end
	return nil
end
function IsBlocked(x,y,team_id)
	if IsInMap(x,y) == false then
		return "map"
	end
	if GameRules:GetGameModeEntity().unit[team_id][y..'_'..x] ~= nil then
		return "unit"
	end
	return false
end
--自制的tk技能
function RandomMissile(keys)
	local caster = keys.caster
	local us = FindUnitsInRadius(caster.team_id,caster:GetAbsOrigin(),nil,600,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST,false)

	local unluckydog = us[RandomInt(1,table.maxn(us))]
	local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team_id) 
	u:AddAbility('a108_missile')
	u:FindAbilityByName('a108_missile'):SetLevel(1)

	if unluckydog == nil then
		return
	end
	
	Timers:CreateTimer(0.1,function()
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
	 		AbilityIndex = u:FindAbilityByName("a108_missile"):entindex(), --Optional.  Only used when casting abilities
	 		Position = nil, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)
		Timers:CreateTimer(5,function()
			u:ForceKill(false)
		end)
	end)

	Timers:CreateTimer(0.3,function()
		if caster == nil or caster:IsNull() == true or caster:IsAlive() == false then
			return
		end
		unluckydog = us[RandomInt(1,table.maxn(us))]
		local v = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team_id) 
		v:AddAbility('a108_missile')
		v:FindAbilityByName('a108_missile'):SetLevel(1)
		
		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = v:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
		 		AbilityIndex = v:FindAbilityByName("a108_missile"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				v:ForceKill(false)
			end)
		end)
	end)
	Timers:CreateTimer(0.5,function()
		if caster == nil or caster:IsNull() == true or caster:IsAlive() == false then
			return
		end
		unluckydog = us[RandomInt(1,table.maxn(us))]
		local v = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team_id) 
		v:AddAbility('a108_missile')
		v:FindAbilityByName('a108_missile'):SetLevel(1)
		
		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = v:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
		 		AbilityIndex = v:FindAbilityByName("a108_missile"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				v:ForceKill(false)
			end)
		end)
	end)
end
--通用方法之添加技能
function AddAbilityAndSetLevel(u,a,l)
	if l == nil then
		l = 1
	end
	if u == nil or u:IsNull() == true then
		return
	end
	if u:FindAbilityByName(a) == nil then
		u:AddAbility(a)
		u:FindAbilityByName(a):SetLevel(l)
	else
		u:FindAbilityByName(a):SetLevel(l)
	end
end
function RemoveAbilityAndModifier(u,a)
	if u == nil or u:IsNull() == true then
		return
	end
	if u:FindAbilityByName(a) ~= nil then
		u:RemoveAbility(a)
		u:RemoveModifierByName('modifier_'..a)
	end
end
function RemoveFromToBeDestroyList(u)
	for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[(u.at_team_id or u.team_id)]) do
		if q:entindex() == u:entindex() then
			table.remove(GameRules:GetGameModeEntity().to_be_destory_list[(u.at_team_id or u.team_id)],p)
		end
	end
end
function SetLordAbilityEnable(hero,b)
	if hero.lord_ability ~= nil and hero:FindAbilityByName(hero.lord_ability) ~= nil then
		hero:FindAbilityByName(hero.lord_ability):SetActivated(b)
	end
end
function prt(t)
	GameRules:SendCustomMessage(''..t,0,0)
end
function debug(t)
	if GameRules:GetGameModeEntity().is_debug == true then
		GameRules:SendCustomMessage(''..t,0,0)
	end
end
function unit2text(u)
	local id1 = u.team_id or 'X'
	local id2 = u.at_team_id or 'X'
	return ''..id1..'-'..id2..'的'..u:GetUnitName()
end
function AttackHeal(keys)
	local target = keys.attacker
	local damage = keys.damage
	local per = keys.per
	target:Heal(damage*per, target)
end
function AddMaxHPPer(keys)
	local caster = keys.caster
	local per = keys.per

	local hp = caster:GetMaxHealth()
	local hp_per = caster:GetHealth()/caster:GetMaxHealth()
	local hp = hp * ((100 + tonumber(per))/100)
	caster:SetBaseMaxHealth(hp)
	caster:SetMaxHealth(hp)
	caster:SetHealth(hp*hp_per)
end
function AddMaxHP(keys)
	local caster = keys.caster
	if caster:IsAncient() == true then
		return
	end
	local hp = keys.hp
	local hp1 = caster:GetMaxHealth()
	local hp_per = caster:GetHealth()/caster:GetMaxHealth()
	local hp1 = hp1 + tonumber(hp)
	caster:SetBaseMaxHealth(hp1)
	caster:SetMaxHealth(hp1)
	caster:SetHealth(hp1*hp_per)
end
function UnAddMaxHP(keys)
	local caster = keys.caster
	if caster:IsAncient() == true then
		return
	end
	local hp = keys.hp
	local hp1 = caster:GetMaxHealth()
	local hp_per = caster:GetHealth()/caster:GetMaxHealth()
	local hp1 = hp1 - tonumber(hp)
	caster:SetBaseMaxHealth(hp1)
	caster:SetMaxHealth(hp1)
	caster:SetHealth(hp1*hp_per)
end
function Bump(keys)
	local p = keys.target_points[1]
	local caster = keys.caster
	local team_id = caster.at_team_id or caster.team_id
	local position = p

	GameRules:GetGameModeEntity().unit[team_id][caster.y_x] = nil
	GameRules:GetGameModeEntity().unit[team_id][Vector2Y(position,team_id)..'_'..Vector2X(position,team_id)] = 1
	InvisibleUnitCast({
		caster = caster,
		ability = 'sandking_burrowstrike',
		level = 1,
		unluckydog = nil,
		position = position,
	})

	Timers:CreateTimer(0.3,function()
		caster:SetAbsOrigin(position)
	end)
end
--辅助功能——创建隐藏单位施法
function InvisibleUnitCast(keys)
	local shiban = keys.caster
	local shiban_ability = keys.ability
	local ability_level = keys.level
	local unluckydog = keys.unluckydog
	local position = keys.position

	local uu = CreateUnitByName("invisible_unit", shiban:GetAbsOrigin() ,false,nil,nil, shiban:GetTeam()) 
	uu.ftd = 2009
	uu:SetOwner(shiban)

	uu:AddAbility(shiban_ability)
	uu:FindAbilityByName(shiban_ability):SetLevel(ability_level)
	Timers:CreateTimer(0.05,function()
		if uu:FindAbilityByName(shiban_ability):GetBehavior() == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			local newOrder = {
		 		UnitIndex = uu:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
		 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
		elseif uu:FindAbilityByName(shiban_ability):GetBehavior() == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			local newOrder = {
		 		UnitIndex = uu:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		TargetIndex = unluckydog:entindex(), --Optional.  Only used when targeting units
		 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
		else
			local newOrder = {
		 		UnitIndex = uu:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		 		TargetIndex = nil, --Optional.  Only used when targeting units
		 		AbilityIndex = uu:FindAbilityByName(shiban_ability):entindex(), --Optional.  Only used when casting abilities
		 		Position = position, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
		end
		Timers:CreateTimer(10,function()
			uu:ForceKill(false)
			uu:Destroy()
		end)
	end)
end
function PlayerId2Hero(id)
	return GameRules:GetGameModeEntity().playerid2hero[id]
end
function TeamId2Hero(id)
	return GameRules:GetGameModeEntity().teamid2hero[id]
end
function GetMaxChessCount(team)
	if TeamId2Hero(team) ~= nil then
		return TeamId2Hero(team):GetLevel()
	else
		return 1
	end
end
function GetStat(id,prop)
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return nil
	end
	return GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop]
end
function SetStat(id,prop,v)
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return
	end
	GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] = v
end
function AddStat(id,prop)
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return
	end
	GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] = GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] + 1
	if prop == 'kills' then
		PlayerResource:IncrementLastHits(id)
	end
	if prop == 'deaths' then
		PlayerResource:IncrementDenies(id)
	end

	if prop == 'win_round' then
		PlayerResource:IncrementKills(id,1)
	end
	if prop == 'lose_round' then
		PlayerResource:IncrementDeaths(id,1)
	end
	if prop == 'draw_round' then
		PlayerResource:IncrementAssists(id,1)
	end
end


function StartGame()
	--5秒后开始游戏
	Timers:CreateTimer(5,function()
		if PlayerResource:GetPlayerCount() == 1 then
			prt('tips_1_player')
		else
			prt('GAME START!')
		end

		--初始化棋子库
		InitChessPool(PlayerResource:GetPlayerCount())

    	GameRules:GetGameModeEntity().START_TIME = GameRules:GetGameTime()
		StartAPrepareRound()
    end)
end
function GameOver()
	GameRules:GetGameModeEntity().is_game_ended = true
	if GameRules:GetGameModeEntity().ended == false then
		CustomNetTables:SetTableValue( "dac_table", "curtain_tips", { text = "#gameover", hehe = RandomInt(1,1000)})
		CustomNetTables:SetTableValue( "dac_table", "game_over", { text = "#gameover", hehe = RandomInt(1,1000)})

		local win_team = 2
		if GameRules:GetGameModeEntity().good_castle.hp > 0 then
			win_team = 2
		end
		if GameRules:GetGameModeEntity().bad_castle.hp > 0 then
			win_team = 3
		end

		for i,v in pairs(GameRules:GetGameModeEntity().hero) do
			if v.team == win_team then
				v:AddAbility('gameover_win')
				v:FindAbilityByName('gameover_win'):SetLevel(1)
			else
				v:AddAbility('gameover_lose')
				v:FindAbilityByName('gameover_lose'):SetLevel(1)
			end
		end

		GameRules:GetGameModeEntity().ended = true
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")

		GameRules:SendCustomMessage('gameover',0,0)

		Timers:CreateTimer(2,function()
			CalScore()
		end)
	end
end


--通过聊天输入执行命令
function DAC:OnPlayerChat(keys)
	local player = GameRules:GetGameModeEntity().userid2player[keys.userid]
	local hero = EntIndexToHScript(player):GetAssignedHero()
	local heroindex = hero:GetEntityIndex()
	local team = hero:GetTeam()
	local tokens =  string.split(string.lower(keys.text))

	if (
		tokens[1] == "-lvlup" or
		tokens[1] == "-createhero" or
		tokens[1] == "-item" or
		tokens[1] == "-refresh" or
		tokens[1] == "-startgame" or 
		tokens[1] == "-killcreeps" or
		tokens[1] == "-wtf" or 
		tokens[1] == "-disablecreepspawn" or
		tokens[1] == "-gold" or 
		tokens[1] == "-lvlup" or
		tokens[1] == "-refresh" or
		tokens[1] == "-respawn" or
		tokens[1] == "dota_create_unit" or 
		tokens[1] == "-ggsimida"
		) then
		if hero ~= nil and hero:IsNull() == false and hero:IsAlive() == true then
			hero:ForceKill(false)
			GameRules:GetGameModeEntity().counterpart[hero:GetTeam()] = -1
			SyncHP(hero)
			ClearHand(hero:GetTeam())
		end
	end
	
	--激活cdkey
	if string.find(keys.text,"^%w%w%w%w%w%p%w%w%w%w%w%p%w%w%w%w%w$") ~= nil then
		local key = string.upper(keys.text)
		local steamid = EntIndexToHScript(heroindex).steam_id
		CustomNetTables:SetTableValue( "dac_table", "cdkey", {
			player_id = player,
			steam_id = steamid,
			text = key,
			hehe = RandomInt(1,10000)
		})
		return
	end

	--特效测试
	if string.find(keys.text,"^e%w%w%w$") ~= nil and GameRules:GetGameModeEntity().myself then
		if hero.effect ~= nil then
			hero:RemoveAbility(hero.effect)
			hero:RemoveModifierByName('modifier_texiao_star')
		end
		hero:AddAbility(keys.text)
		hero:FindAbilityByName(keys.text):SetLevel(1)
		hero.effect = keys.text
	end

	if tokens[1] == '-chesspool' and GameRules:GetGameModeEntity().myself then
		PrintChessPool()
	end

	--测试命令
	if tokens[1] == '-up' and GameRules:GetGameModeEntity().myself then
		local lineup_table = {}
		for _,savechess in pairs(GameRules:GetGameModeEntity().mychess[team]) do
			table.insert(lineup_table,{
				x = savechess.x,
				y = savechess.y,
				lastitem = CopyTable(savechess.lastitem),
				chess = savechess.chess
			})
		end
		local obj = {
			owner = EntIndexToHScript(heroindex).steam_id,
			lineup = lineup_table,
			round = GameRules:GetGameModeEntity().battle_round
		}
		local url = "http://autochess.ppbizon.com/lineup/add?lineups="..json.encode(obj).."&hehe="..RandomInt(1,10000)
		local req = CreateHTTPRequestScriptVM("GET", url)
		req:SetHTTPRequestAbsoluteTimeoutMS(20000)
		req:Send(function (result)
			local t = json.decode(result["Body"])
			if t.err == 0 then
				prt(''..hero.player_name..'云阵容保存成功')
			end
		end)
	end
	if tokens[1] == '-tp' then
		local p = Entities:FindByName(nil,'center'..(team-6)):GetAbsOrigin()
		hero:SetAbsOrigin(p)
	end
	if tokens[1] == '-crab' and GameRules:GetGameModeEntity().myself == true then
		GameRules:GetGameModeEntity().next_crab = 'chess_'..tokens[2]
		for i=1,3 do
			local x = nil
			local this_chess = nil
			if i == 1 then
				this_chess = GameRules:GetGameModeEntity().next_crab
			elseif i == 2 then
				this_chess = GameRules:GetGameModeEntity().next_crab..'1'
			elseif i == 3 then
				this_chess = GameRules:GetGameModeEntity().next_crab..'11'
			end
			x = CreateUnitByName(this_chess,HandIndex2Vector(hero:GetTeam(),i),true,nil,nil,hero:GetTeam())
			MakeTiny(x)
			PlayChessDialogue(x,'spawn')

			

			GameRules:GetGameModeEntity().hand[hero:GetTeam()][i] = 1
			if hero.hand_entities == nil then
				hero.hand_entities = {}
			end

			hero.hand_entities[i] = x

			x:SetForwardVector(Vector(0,1,0))
			x.hand_index = i
			x.team_id = hero:GetTeam()
			x.owner_player_id = GameRules:GetGameModeEntity().team2playerid[hero:GetTeam()]
			
			AddAbilityAndSetLevel(x,'root_self')
			AddAbilityAndSetLevel(x,'jiaoxie_wudi')

			play_particle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon_bright.vpcf",PATTACH_ABSORIGIN_FOLLOW,x,5)
		end
		GameRules:GetGameModeEntity().next_crab = nil
	end
	if tokens[1] == '-drop' and GameRules:GetGameModeEntity().myself == true then
		local i = 'item_'..tokens[2]
		local newItem = CreateItem( i, hero, hero )
		local drop = CreateItemOnPositionForLaunch(hero:GetAbsOrigin(), newItem )
		local dropRadius = RandomFloat( 50, 200 )
		newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, hero:GetAbsOrigin() + RandomVector(dropRadius ))
	end
	--添加木桩
	if tokens[1] == "-stub" and GameRules:GetGameModeEntity().myself == true then
		local team_id = hero:GetTeam()
		Timers:CreateTimer(function()
			local grid = GameRules:GetGameModeEntity().unit[team_id]
			for i,iv in pairs(grid) do
				if iv == 1 then
					local x = string.split(i,'_')[2]
					local y = string.split(i,'_')[1]
					local u = CreateUnitByName("stub",XY2Vector(x,y,team_id),true,nil,nil,DOTA_TEAM_BADGUYS)
					u:SetHullRadius(1)
					u:SetForwardVector(Vector(-1,-1,0))
					AddAbilityAndSetLevel(u,'jiaoxie_wudi')
					Timers:CreateTimer(0.5,function()
						u:Destroy()
					end)
				end
			end
			return 0.5
		end)
			
		prt('add test stub.')
	end

	if tokens[1] == "-choose" and GameRules:GetGameModeEntity().myself == true then
		prt('choose round: '..tokens[2] )
		GameRules:GetGameModeEntity().battle_round = tonumber(tokens[2])
	end

	if tokens[1] == '-mana' and GameRules:GetGameModeEntity().myself == true then
		prt('MANA!!!')
		AddMana(hero, 100)
	end
	if tokens[1] == '-win' and GameRules:GetGameModeEntity().myself == true then
		local win_count = tonumber(tokens[2] or '1')
		prt('WIN!!!')
		for i=1,win_count do
			AddWinStreak(hero:GetTeam())
		end
	end
	if tokens[1] == "-a" and GameRules:GetGameModeEntity().myself == true then
		local level = tonumber(tokens[3]) or 4
		hero:AddAbility(tokens[2])
		hero:FindAbilityByName(tokens[2]):SetLevel(level)
	end
	if tokens[1] == "-hero" and GameRules:GetGameModeEntity().myself == true then
		local onduty_hero_model = GameRules:GetGameModeEntity().sm_hero_list[tokens[2]]
		hero:SetOriginalModel(onduty_hero_model)
		hero:SetModel(onduty_hero_model)
		hero.init_model_scale = GameRules:GetGameModeEntity().sm_hero_size[tokens[2]] or 1
		hero:SetModelScale(hero.init_model_scale)
		hero.ori_model = onduty_hero_model
		prt('更换信使：'..tokens[2]..', 初始大小：'..hero.init_model_scale)
	end
	if tokens[1] == "-size" and GameRules:GetGameModeEntity().myself == true then
		hero.init_model_scale = tokens[2]+0
		hero:SetModelScale(hero.init_model_scale)
		prt('更换信使大小：'..tokens[2])
	end

	if tokens[1] == '-hand' and GameRules:GetGameModeEntity().myself == true then
		prt('显示玩家'..player..'(team='..team..')的手牌：')
		for i=1,8 do
			local unitname = ''
			if hero.hand_entities[i] ~= nil then
				unitname = hero.hand_entities[i]:GetUnitName()
			else
				unitname = '空的'
			end
			prt('#'..i..'-->'..GameRules:GetGameModeEntity().hand[team][i]..'('..unitname..')')
		end
	end

	if tokens[1] == '-damage' and GameRules:GetGameModeEntity().myself == true then
		prt('SHOW DAMAGE')
		GameRules:GetGameModeEntity().show_damage = true
	end
	if tokens[1] == '-undamage' and GameRules:GetGameModeEntity().myself == true then
		prt('HIDE DAMAGE')
		GameRules:GetGameModeEntity().show_damage = false
	end

	if tokens[1] == '-debug' and GameRules:GetGameModeEntity().myself == true then
		prt('DEBUG ON!')
		GameRules:GetGameModeEntity().is_debug = true
	end
	if tokens[1] == '-undebug' and GameRules:GetGameModeEntity().myself == true then
		prt('DEBUG OFF!')
		GameRules:GetGameModeEntity().is_debug = false
	end

	-- if tokens[1] == '-catch' and GameRules:GetGameModeEntity().myself == true then
	-- 	prt('CATCH CRAB')
	-- 	DAC:OnCatchCrab({
	-- 		url=tokens[2],
	-- 		cb='aaa'
	-- 	})
	-- end

	

	-- ShowCombat({
	-- 	t = 'say',
	-- 	player = hero:GetPlayerID(),
	-- 	text = keys.text
	-- })

	-- CustomNetTables:SetTableValue( "dac_table", "say_bubble", {text = keys.text, unit = heroindex, hehe = RandomInt(1,10000)} )

	--发弹幕
	CustomGameEventManager:Send_ServerToAllClients("bullet",{
		player_id = hero:GetPlayerID(),
		text = keys.text
	})
end
function play_particle(p, pos, u, d)
	-- if u == nil then
	-- 	return
	-- end
	local pp = ParticleManager:CreateParticle(p, pos, u)
	-- Timers:CreateTimer(function()
	-- 	if u:IsNull() ~= false or u:IsAlive() ~= false then
	-- 		ParticleManager:DestroyParticle(pp,true)
	-- 		return
	-- 	end
	-- 	return 1
	-- end)
	Timers:CreateTimer(d,function()
		if pp ~= nil then
			ParticleManager:DestroyParticle(pp,true)
		end
	end)
end
function PlayParticleOnUnitUntilDeath(keys)
	local p = keys.p
	local u = keys.caster
	if u == nil then
		return
	end
	local pos = keys.pos or PATTACH_ABSORIGIN_FOLLOW
	local pp = ParticleManager:CreateParticle(p, pos, u)
	ParticleManager:SetParticleControlEnt( pp, 0, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 1, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 2, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 3, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 4, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 5, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( pp, 6, u, PATTACH_ABSORIGIN_FOLLOW, nil, u:GetOrigin(), true );

	Timers:CreateTimer(0.1,function()
		if u == nil or u:IsNull() == true or u:IsAlive() == false then
			ParticleManager:DestroyParticle(pp,true)
		end
		return 0.1
	end)
end
--高级选取单位，适应所有team
function FindUnitsInRadiusByTeam(keys)
	local team = keys.team
	local role = keys.role or 1 --1=队友,2=敌人,3=全部
	local radius = keys.radius or 500
	local position = keys.position or Vector(0,0,0)
	local units = {}

	local all_units = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS,
		Vector(0,0,0),
		nil,
		9999,
		DOTA_UNIT_TARGET_TEAM_BOTH,  --用BOTH可以选到所有team的单位
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for u,v in pairs(all_units) do
		if (v:GetAbsOrigin() - position):Length2D() <= radius then
			if role == 1 and v:GetTeam() == team then
				table.insert(units,v)
			end
			if role == 2 and v:GetTeam() ~= team then
				table.insert(units,v)
			end
			if role == 3 then
				table.insert(units,v)
			end
		end
	end

	return units
end

function ApplyDamageInRadius(keys)
	local caster = keys.caster
	local team = keys.team
	local role = keys.role or 2
	local position = keys.position
	local damage = keys.damage or 1
	local radius = keys.radius or 500
	local damage_type = keys.damage_type or DAMAGE_TYPE_MAGICAL
	local delay = keys.delay or 0

	Timers:CreateTimer(delay,function()
		local unlucky_dogs = FindUnitsInRadiusByTeam({
			team = team,
			role = role,
			position = position,
			radius = radius,
		})
		for _,u in pairs(unlucky_dogs) do
			if u ~= nil and u:IsNull() == false and u:IsAlive() == true then
				ApplyDamage({
					victim = u,
					attacker = caster,
					damage_type = damage_type,
					damage = damage
				})
			end
		end 
	end)
end
function AddModifierInRadius(keys)
	local caster = keys.caster
	local team = caster:GetTeam()
	local role = keys.role or 2
	local radius = keys.radius or 500
	local modifier = keys.modifier
	local ability = keys.ability
	local unlucky_dogs = FindUnitsInRadiusByTeam({
		team = team,
		role = role,
		position = caster:GetAbsOrigin(),
		radius = radius,
	})
	for _,u in pairs(unlucky_dogs) do
		if u ~= nil and u:IsNull() == false and u:IsAlive() == true then
			u:AddNewModifier(caster,keys.ability,modifier,nil)
		end
	end
end


function ChangeModelScale(keys)
	local u = keys.caster
	local x = keys.x
	local s = u:GetModelScale()
	-- u:SetModelScale(s*x)
	AddModelScalePlus(u, s*x)
	play_particle("effect/big.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,2)
end

function RemoveTableItem(t,item)
	for i,v in pairs (t) do
		if v == item then
			table.remove(t,i)
			return t
		end
	end
end
function show_damage(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local damage = math.floor(keys.DamageTaken)

	--格挡
	local gedang = 0
	local gedang_per = 0
	if caster:FindModifierByName('modifier_item_yuandun') ~= nil then
		gedang = 10
		gedang_per = 100
	end
	if caster:FindModifierByName('modifier_item_xianfengdun') ~= nil then
		gedang = 50
		gedang_per = 50
	end
	if gedang > 0 and RandomInt(1,100) < gedang_per then
		local caster_hp = caster:GetHealth()
		if damage < gedang then
			if caster_hp > damage then
				caster:SetHealth(caster_hp+damage)
				damage = 0
			end
		else
			if caster_hp > damage then
				caster:SetHealth(caster_hp+gedang)
				damage = damage - gedang
			end
		end
	end

	if damage <= 0 then
		return
	end

	if attacker ~= nil and attacker:IsHero() == true then
		return
	end

	--回蓝

	--受到伤害回蓝
	local mana_get = damage/5
	if mana_get > 50 then
		mana_get = 50
	end
	mana_get = RandomInt(mana_get/2,mana_get)
	
	if caster:FindModifierByName("modifier_item_jixianfaqiu") ~= nil  then
		mana_get = math.floor(mana_get * 1.25)
	end
	if caster:FindModifierByName("modifier_item_yangdao") ~= nil then
		mana_get = math.floor(mana_get * 1.5)
	end
	caster:SetMana(caster:GetMana()+mana_get)

	--造成伤害回蓝
	if attacker ~= nil then
		if attacker:FindAbilityByName('is_mage') or attacker:FindAbilityByName('is_warlock') or attacker:FindAbilityByName('is_shaman') then
			mana_get = damage/2.5
			if mana_get > 20 then
				mana_get = 20
			end
		else
			if mana_get > 10 then
				mana_get = 10
			end
		end 
		
		if attacker:FindModifierByName("modifier_item_wangguan") ~= nil or attacker:FindModifierByName("item_hongzhang_1") ~= nil or attacker:FindModifierByName("item_hongzhang_2") ~= nil or attacker:FindModifierByName("item_hongzhang_3") ~= nil or attacker:FindModifierByName("item_hongzhang_4") ~= nil or attacker:FindModifierByName("item_hongzhang_5") ~= nil then
			mana_get = math.floor(mana_get * 1.5)
		end
		if attacker:FindModifierByName("modifier_item_xuwubaoshi") ~= nil or attacker:FindModifierByName("modifier_item_yangdao") ~= nil or caster:FindModifierByName("modifier_item_shenmifazhang") ~= nil then
			mana_get = math.floor(mana_get * 2)
		end
		if attacker:FindModifierByName("modifier_item_jianrenqiu") ~= nil then
			mana_get = math.floor(mana_get * 2)
		end
		if attacker:FindModifierByName("modifier_item_shuaxinqiu") ~= nil then
			mana_get = math.floor(mana_get * 3)
		end
		
		attacker:SetMana(attacker:GetMana()+mana_get)
	end

	if GameRules:GetGameModeEntity().show_damage == true then
		if attacker:GetTeam() == 4 then
			AMHC:CreateNumberEffect(caster,damage,2,AMHC.MSG_DAMAGE,"red",9)
		else
			AMHC:CreateNumberEffect(caster,damage,2,AMHC.MSG_DAMAGE,"green",9)
		end
	end

	--伤害统计
	if attacker ~= nil then
		local attacker_id = attacker:GetEntityIndex()
		local team_id = attacker.team_id
		-- if attacker.at_team_id == attacker.team_id then
			if team_id == nil or GameRules:GetGameModeEntity().damage_stat[team_id] == nil then
				return
			end
			local curr_damage = GameRules:GetGameModeEntity().damage_stat[team_id][attacker:GetUnitName()]
			if curr_damage == nil then
				curr_damage = 0
			end
			curr_damage = curr_damage + damage
			GameRules:GetGameModeEntity().damage_stat[team_id][attacker:GetUnitName()] = curr_damage
		-- end

		local g_time = GameRules:GetGameTime()
		if GameRules:GetGameModeEntity()['last_g_time'..team_id] == nil then
			GameRules:GetGameModeEntity()['last_g_time'..team_id] = 0
		end
		local time_this_level = 61 - GameRules:GetGameModeEntity().battle_timer
		if g_time - GameRules:GetGameModeEntity()['last_g_time'..team_id] > 1 then
			GameRules:GetGameModeEntity()['last_g_time'..team_id] = g_time
		end
	end
end
function RenJia(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local damage = math.floor(keys.DamageTaken*0.1)
	if damage <= 0 then
		return
	end
    ApplyDamage({
    	victim=attacker,
    	attacker=caster,
    	damage_type=DAMAGE_TYPE_PURE,
    	damage=damage
    })
end
--电锤技能
function DianChui(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targets = event.targets
	local damage = event.damage
	local particle = event.particle or "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"

	-- Make sure the main target is damaged
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ApplyDamage({ 
		victim = target, 
		attacker = caster, 
		damage = damage, 
		damage_type = DAMAGE_TYPE_MAGICAL
	})

	-- local cone_units = GetEnemiesInCone( caster, start_radius, end_radius, end_distance )
	local cone_units = FindUnitsInRadiusByTeam({
			team = caster:GetTeam(),
			role = 2,
			position = caster:GetAbsOrigin(),
			radius = 500,
		})
	local targets_shocked = 1 --Is targets=extra targets or total?
	for _,unit in pairs(cone_units) do
		if targets_shocked < targets then
			if unit ~= target then
				if unit.player == nil or unit.player == caster:GetOwner():GetPlayerID() then
					-- Particle
					local origin = unit:GetAbsOrigin()

					local lightningBolt = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
					ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
					ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
				
					-- Damage
					ApplyDamage({ 
						victim = unit, 
						attacker = caster, 
						damage = damage, 
						damage_type = DAMAGE_TYPE_MAGICAL
					})

					-- Increment counter
					targets_shocked = targets_shocked + 1
				end
				
			end
		else
			break
		end
	end
end


function string.split(s, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(s, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

--主公的技能
function h101_ability(h)
	if h~=nil and h:IsNull() ~= true and h:IsAlive() ~= false and h:GetHealth() < h:GetMaxHealth() then
		Timers:CreateTimer(RandomFloat(0,0.2),function()
			h:SetHealth(h:GetHealth()+1)
			play_particle("particles/items2_fx/tranquil_boots_healing.vpcf",PATTACH_ABSORIGIN_FOLLOW,h,2)
			EmitSoundOn('DOTA_Item.TranquilBoots.Activate',h)
			SyncHP(h)
		end)
	end
end
function h203_addattackdamage(keys)
	local h = keys.caster
	for i,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[h:GetTeam()]) do
		if v.team_id == h:GetTeam() then
			AddAbilityAndSetLevel(v,'h203_attack_increased')
			EmitSoundOn('Hero_Beastmaster.Call.Boar',v)
		end
	end
end
function h301_restoreallhealth(keys)
	local h = keys.caster
	for i,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[h:GetTeam()]) do
		if v.team_id == h:GetTeam() then
			v:SetHealth(v:GetMaxHealth())
			play_particle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",PATTACH_ABSORIGIN_FOLLOW,v,2)
			EmitSoundOn('Hero_Omniknight.Purification',v)
		end
	end
end
function h302_ability(h)
	AddAbilityAndSetLevel(h,'h302_maxmanaplus20')
end
function h401_ability(keys)
	local h = keys.caster
	AMHC:CreateParticle("particles/econ/items/puck/puck_alliance_set/puck_dreamcoil_waves_rope_aproset.vpcf",PATTACH_OVERHEAD_FOLLOW,false,h,5)
	for i,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[h:GetTeam()]) do
		if v.team_id ~= h:GetTeam() then
			AddAbilityAndSetLevel(v,'h401_letaojiao')
		end
	end
end
function h402_ability(keys)
	local h = keys.caster
	play_particle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings_grow_rope.vpcf",PATTACH_ABSORIGIN_FOLLOW,h,5)
	for i,v in pairs(GameRules:GetGameModeEntity().to_be_destory_list[h:GetTeam()]) do
		if v.team_id ~= h:GetTeam() then
			local damageTable = {
		    	victim=v,
		    	attacker=h,
		    	damage_type=DAMAGE_TYPE_MAGICAL,
		    	damage=v:GetMaxHealth()/2
		    }
		    ApplyDamage(damageTable)
			play_particle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",PATTACH_ABSORIGIN_FOLLOW,v,2)
		end
	end
end

function DAC:OnRefreshChess(keys)
	local hero = GameRules:GetGameModeEntity().teamid2hero[keys.team]
	if hero:GetMana() < 2 then
		CustomGameEventManager:Send_ServerToTeam(keys.team,"mima",{
			text = "text_mima_no_mana"
		})
		return
	else
		hero.chesslock = false
		hero:SetMana(hero:GetMana()-2)
		Draw5ChessAndShow(keys.team, true)
		CustomGameEventManager:Send_ServerToTeam(keys.team,"show_gold",{
			gold = hero:GetMana(),
			lose_streak = hero.lose_streak or 0,
			win_streak = hero.win_streak or 0,
		})
	end
end

--技能：抽
function SummonHero(keys)
	local caster = keys.caster
	local team_id = caster:GetTeam()
	caster.chesslock = false

	-- local target_index = FindEmptyHandSlot(team_id)
	
	-- if target_index == nil then
	-- 	--手牌已经满了
	-- 	CustomGameEventManager:Send_ServerToTeam(caster:GetTeam(),"mima",{
	-- 		text = "text_mima_hand_is_full"
	-- 	})
	-- 	EmitSoundOn("General.CastFail_NoMana",keys.caster)
	-- 	--把蓝加回来
	-- 	caster:SetMana(caster:GetMana()+2)
	-- 	CustomNetTables:SetTableValue( "dac_table", "show_gold", { gold = caster:GetMana(), hehe = RandomInt(1,1000)})
	-- 	return
	-- end

	-- RandomOneChessInHand(team_id)
	AMHC:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon_bright.vpcf",PATTACH_ABSORIGIN_FOLLOW,false,caster,5)
	EmitSoundOn('frostivus_ui_select',caster)
	-- setHandStatus(team_id)

	Draw5ChessAndShow(team_id, true)

	CustomGameEventManager:Send_ServerToTeam(team_id,"show_gold",{
		gold = caster:GetMana(),
		lose_streak = caster.lose_streak or 0,
		win_streak = caster.win_streak or 0,
	})
end

function ExpBook(keys)
	local caster = keys.caster
	local team_id = caster:GetTeam()
	caster:AddExperience (4,0,false,false)
	AMHC:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf",PATTACH_ABSORIGIN_FOLLOW,false,caster,5)
	-- EmitSoundOn('General.Combine',caster)
	EmitSoundOn('Hero_Omniknight.GuardianAngel',caster)
	-- setHandStatus(team_id)

	AMHC:CreateNumberEffect(caster,4,3,AMHC.MSG_MISS,{255,255,128},0)
	CustomGameEventManager:Send_ServerToTeam(team_id,"show_gold",{
		gold = caster:GetMana(),
		lose_streak = caster.lose_streak or 0,
		win_streak = caster.win_streak or 0,
	})
end

function AddMana(unit, mana)
	if mana == nil or mana <= 0 then
		return
	end
	unit:SetMana(unit:GetMana()+mana)
	AMHC:CreateParticle("particles/generic_gameplay/rune_bounty_owner.vpcf",PATTACH_OVERHEAD_FOLLOW,false,unit,5)
	if mana >= 10 then
		EmitSoundOn("General.CoinsBig",unit)
	else
		EmitSoundOn("General.Coins",unit)
	end

	AMHC:CreateNumberEffect(unit,mana,3,AMHC.MSG_MISS,{255,255,0},0)
end

function CostMana(unit, mana)
	if mana == nil or mana <= 0 then
		return
	end
	unit:SetMana(unit:GetMana()-mana)
	-- AMHC:CreateNumberEffect(unit,mana,4,AMHC.MSG_EVADE,{255,255,128},3)
end

function AddModelScalePlus(unit, scale)
	unit.target_scale = scale
	Timers:CreateTimer(0.01,function()
		if unit == nil or unit:IsNull() == true or unit:IsAlive() == false or unit:GetModelScale() >= unit.target_scale then
			return
		end
		unit:SetModelScale(unit:GetModelScale()+0.01)
		return 0.01
	end)
end

function CmManaAura(keys)
	local caster = keys.caster
	local ability_level = keys.ability:GetLevel()
	local at_team_id = caster.at_team_id or caster.team_id
	local team_id = caster.team_id
	local radius = keys.radius or 800
	local mana = keys.mana or 5

	-- print('CmManaAura '..at_team_id..'/'..team_id)
	for _,unit in pairs(GameRules:GetGameModeEntity().to_be_destory_list[at_team_id]) do
		-- print(unit:GetUnitName()..' team='..unit.team_id)
		if unit.team_id == team_id and unit:GetMaxMana() ~= 0 then
			--add mana
			-- print(unit:GetUnitName()..' ADD MANA!')
			play_particle('particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_matter_manasteal.vpcf',PATTACH_OVERHEAD_FOLLOW,unit,3)
			unit:SetMana(unit:GetMana()+mana)
		end
	end
end

function PlayChessDialogue(unit,dialogue)
	if unit == nil or unit:IsNull() == true or unit:IsAlive() == false then
		return
	end
	play_particle("particles/speechbubbles/speech_voice.vpcf",PATTACH_OVERHEAD_FOLLOW,unit,3)
	CustomGameEventManager:Send_ServerToTeam(unit:GetTeam(),"play_chess_dialogue",{
		unit_index = unit:GetEntityIndex(),
		unit_name = unit:GetUnitName(),
		dialogue_type = dialogue, --spawn/win/merge
	})
end

function TriggerRefreshOrb(u)
	if u:FindModifierByName("modifier_item_shuaxinqiu") == nil then
		return 
	end

	for slot=0,8 do
		if u:GetItemInSlot(slot)~= nil then
			local ability = u:GetItemInSlot(slot)
			local name = ability:GetAbilityName()
			local a = GameRules:GetGameModeEntity().chess_ability_list[u:GetUnitName()]

			if name == 'item_shuaxinqiu' and ability:IsCooldownReady() == true and u:FindAbilityByName(a):IsCooldownReady() == false then
				--刷新！！
				ability:StartCooldown(30)
				
				u:FindAbilityByName(a):EndCooldown()

				play_particle("particles/items2_fx/refresher.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,5)
				EmitSoundOn("DOTA_Item.Refresher.Activate",u)

				return 1
			end
		end
	end
end

function TriggerSheepStick(u)
	if u:FindModifierByName("modifier_item_yangdao") == nil then
		return 
	end

	for slot=0,8 do
		if u:GetItemInSlot(slot)~= nil then
			local ability = u:GetItemInSlot(slot)
			local name = ability:GetAbilityName()
			if name == 'item_yangdao' and ability:IsCooldownReady() == true then
				if u:FindAbilityByName("crab_voodoo") == nil then
					AddAbilityAndSetLevel(u,'crab_voodoo')
				else
					local dog = FindUnluckyDog(u)
					if u:IsNull() ~= true and dog ~= nil and dog:IsNull() ~= true then
						ability:StartCooldown(30)
						local newOrder = {
					 		UnitIndex = u:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					 		TargetIndex = dog:entindex(), 
					 		AbilityIndex = u:FindAbilityByName("crab_voodoo"):entindex(), 
					 		Position = nil, 
					 		Queue = 0 
					 	}
						ExecuteOrderFromTable(newOrder)
					end
				end
				return 1
			end
		end
	end
end

function TriggerTiaodao(u)
	if u:FindModifierByName("modifier_item_tiaodao") == nil then
		return 
	end

	for slot=0,8 do
		if u:GetItemInSlot(slot)~= nil then
			local ability = u:GetItemInSlot(slot)
			local name = ability:GetAbilityName()
			if name == 'item_tiaodao' and ability:IsCooldownReady() == true then
				find_ok = FindCurrColFarthestCanAttackPosition(u)
				if find_ok ~= nil then
					local x = Vector2X(find_ok,u.at_team_id or u.team_id)
					local y = Vector2Y(find_ok,u.at_team_id or u.team_id)
					local xx = u.x
					local yy = u.y
					GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][y..'_'..x] = 1
					u:SetAbsOrigin(find_ok)
					u.y_x = y..'_'..x
					u.y = y
					u.x = x
					GameRules:GetGameModeEntity().unit[u.at_team_id or u.team_id][yy..'_'..xx] = nil

					play_particle("particles/items_fx/blink_dagger_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,3)
					EmitSoundOn("DOTA_Item.BlinkDagger.Activate",u)

					ability:StartCooldown(15)
				else
					return
				end

				return 1
			end
		end
	end
end

function TriggerFrogGua(u)
	if u:FindAbilityByName("frog_voodoo") == nil then
		return 
	end
	local dog = FindUnluckyDog(u)
	if dog ~= nil and u:FindAbilityByName("frog_voodoo"):IsCooldownReady() == true then
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = dog:entindex(), 
	 		AbilityIndex = u:FindAbilityByName("frog_voodoo"):entindex(), 
	 		Position = nil, 
	 		Queue = 0 
	 	}
		ExecuteOrderFromTable(newOrder)
		-- u:FindAbilityByName("frog_voodoo"):StartCooldown(60)
		-- Timers:CreateTimer(2,function()
		-- 	u:RemoveAbility("frog_voodoo")
		-- end)
		return 1
	end
end

function TriggerDagon(u)
	if u:FindModifierByName("modifier_item_hongzhang") == nil then
		return 
	end
	for slot=0,8 do
		if u:GetItemInSlot(slot)~= nil then
			local ability = u:GetItemInSlot(slot)
			local name = ability:GetAbilityName()
			local name_table = string.split(name,'_')
			local dog = FindUnluckyDog(u)
			if dog ~= nil and name_table[2] == 'hongzhang' and ability:IsCooldownReady() == true then
				ability:StartCooldown(30)
				EmitSoundOn("DOTA_Item.Dagon.Activate",u)
				local victim = dog
				local info = {
			        Target = victim,
			        Source = u,
			        Ability = nil,
			        EffectName = "particles/econ/events/ti5/dagon_ti5.vpcf",
			        bDodgeable = false,
			        iMoveSpeed = 3000,
			        bProvidesVision = false,
			        iVisionRadius = 0,
			        iVisionTeamNumber = u:GetTeamNumber(),
			        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			    }
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				ApplyDamage({
			    	victim=victim,
			    	attacker=u,
			    	damage_type=DAMAGE_TYPE_MAGICAL,
			    	damage=300+100*tonumber(name_table[3])
			    })
				return 1
			end
		end
	end
end

function ChessTechBomb(keys)
	local caster = keys.caster
	local p = keys.target_points[1]
	local explode_time = keys.explode_time or 5
	local damage = keys.damage or 800
	local scale = keys.scale or 1.2
	local range = keys.range or 400
	local at_team = caster.at_team_id or caster.team_id
	local team = caster:GetTeam()

	if p == nil then
		-- prt('DEBUG: 炸药桶的位置是nil')
		return
	end

	local y = Vector2Y(p,at_team)
	local x = Vector2X(p,at_team)

	if (GameRules:GetGameModeEntity().unit[at_team][y..'_'..x] ~= nil) then
		debug('炸药桶的位置不是空格子')
		return
	end

	--创建一个炸弹
	GameRules:GetGameModeEntity().unit[at_team][y..'_'..x] = 1
	local u = CreateUnitByName('enemy_bomb',p,true,nil,nil,team)
	u:SetModelScale(scale)
	EmitSoundOn("Hero_Techies.RemoteMine.Plant",u)
	play_particle("particles/units/heroes/hero_techies/techies_remote_mine.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,3)

	Timers:CreateTimer(explode_time, function()
		GameRules:GetGameModeEntity().unit[at_team][y..'_'..x] = 0
		--爆炸
		EmitSoundOn("Hero_Techies.RemoteMine.Detonate",u)
		play_particle("particles/dac/zhayaotong/zhayaotong.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,2)
		--伤害
		-- prt('爆炸，caster是'..caster:GetTeam()..'队的')
		ApplyDamageInRadius({
			caster = caster,
			team = team,
			radius = range,
			role = 2,
			position = u:GetAbsOrigin(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		})
		u:SetModelScale(0.001)
		Timers:CreateTimer(2,function()
			u:Destroy()
		end)
	end)
end

function LycSummonWolf(keys)
	local ability = keys.ability
	local caster = keys.caster
	local level = ability:GetLevel() or 1
	local hp_per = keys.hp_per
	play_particle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,3)
	EmitSoundOn("Hero_Lycan.Shapeshift.Cast",caster)

	local lyc_model = {
		[1] = "models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl",--"models/heroes/lycan/lycan_wolf.vmdl",
		[2] = "models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl",
		[3] = "models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl",
	}
	local shift_model = lyc_model[level]
	if shift_model ~= nil then
		caster:SetOriginalModel(shift_model)
		caster:SetModel(shift_model)
		AddMaxHPPer({
			caster = caster,
			per = hp_per
		})
	end

	Timers:CreateTimer(0.1,function()
		local w = SummonOneMinion(caster,'lyc_wolf'..level)
		ExtendBeastBuff(w,caster)
		Timers:CreateTimer(0.2,function()
			local w = SummonOneMinion(caster,'lyc_wolf'..level)
			ExtendBeastBuff(w,caster)
		end)
	end)
end

function TbMohua(keys)
	local ability = keys.ability
	local caster = keys.caster
	local level = ability:GetLevel() or 1

	EmitSoundOn('Hero_Terrorblade.Sunder.Cast',caster)

	play_particle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,3)

	local mohua_model = {
		[1] = "models/heroes/terrorblade/demon.vmdl",
		[2] = "models/items/terrorblade/knight_of_foulfell_demon/knight_of_foulfell_demon.vmdl",
		[3] = "models/items/terrorblade/dotapit_s3_fallen_light_metamorphosis/dotapit_s3_fallen_light_metamorphosis.vmdl",
	}
	local shift_model = mohua_model[level]
	if shift_model ~= nil then
		caster:SetOriginalModel(shift_model)
		caster:SetModel(shift_model)
	end
end

function VenoSummonWard(keys)
	local ability = keys.ability
	local caster = keys.caster
	local level = ability:GetLevel() or 1
	local p = keys.target_points[1]

	Timers:CreateTimer(0.1,function()
		local w = SummonOneMinion(caster,'veno_ward'..level, p)
		ExtendBeastBuff(w,caster)
	end)
end
--召唤物继承野兽buff
function ExtendBeastBuff(unit,owner)
	if owner:FindAbilityByName('is_beast_buff')~=nil then
		AddAbilityAndSetLevel(unit,'is_beast_buff')
	end
	if owner:FindAbilityByName('is_beast_buff_plus')~=nil then
		AddAbilityAndSetLevel(unit,'is_beast_buff_plus')
	end
	if owner:FindAbilityByName('is_beast_buff_plus_plus')~=nil then
		AddAbilityAndSetLevel(unit,'is_beast_buff_plus_plus')
	end
end
function FurTree(keys)
	local ability = keys.ability
	local caster = keys.caster
	local level = ability:GetLevel() or 1
	local p = keys.target_points[1]

	print(caster:GetAbsOrigin())
	print(p)

	Timers:CreateTimer(0.1,function()
		local w = SummonOneMinion(caster, 'fur_tree'..level, p)
		ExtendBeastBuff(w,caster)
	end)
end
function LdBear(keys)
	local ability = keys.ability
	local caster = keys.caster
	local level = ability:GetLevel() or 1

	Timers:CreateTimer(0.1,function()
		local w = SummonOneMinion(caster,'ld_bear'..level)
		ExtendBeastBuff(w,caster)
	end)
end
function CKillusion(keys)
	local caster = keys.caster
	play_particle("particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,3)
	EmitSoundOn("Hero_ChaosKnight.Phantasm",caster)
	Timers:CreateTimer(0.1,function()
		local i1 = SummonOneMinion(caster,'chess_ck_ssr_illusion')
		i1:AddNewModifier(i1,nil,"modifier_illusion",nil)
		Timers:CreateTimer(0.2,function()
			local i2 = SummonOneMinion(caster,'chess_ck_ssr_illusion')
			i2:AddNewModifier(i1,nil,"modifier_illusion",nil)
			Timers:CreateTimer(0.3,function()
				local i3 = SummonOneMinion(caster,'chess_ck_ssr_illusion')
				i3:AddNewModifier(i1,nil,"modifier_illusion",nil)
			end)
		end)
	end)
end
function SummonOneMinion(caster, minion, p)
	if caster == nil then
		return
	end
	local v = p or FindEmptyGridAtUnit(caster)
	local teamid = caster.team_id
	local at_teamid = caster.at_team_id or caster.team_id
	if v == nil then
		return
	end
	if teamid == nil then
		return
	end
	if at_teamid == nil then
		return
	end
	local x = CreateUnitByName(minion,v,true,nil,nil,teamid)

	table.insert(GameRules:GetGameModeEntity().to_be_destory_list[at_teamid],x)
	x:SetForwardVector(caster:GetForwardVector())
	AddAbilityAndSetLevel(x,'root_self')
	AddAbilityAndSetLevel(x,'jiaoxie_wudi')
	x.x = Vector2X(v,at_teamid)
	x.y = Vector2Y(v,at_teamid)
	x.y_x = ''..x.y..'_'..x.x
	if caster.at_team_id ~= nil then
		x.at_team_id = caster.at_team_id
	end
	if caster.team_id ~= nil then
		x.team_id = caster.team_id
	end
	GameRules:GetGameModeEntity().unit[at_teamid][x.y..'_'..x.x] = 1
	Timers:CreateTimer(function()
		if x == nil or x:IsNull() == true or x:IsAlive() == false or x.alreadywon == true then
			return
		end
		ChessAI(x)
		return 1
	end)

	return x
end

function FindAClosestEnemyAndAttack(u)
	--已经有目标
	if u.attack_target ~= nil and u.attack_target:IsInvisible() == false and u.attack_target:IsNull() == false and u.attack_target:IsAlive() == true and (u.attack_target:GetAbsOrigin() - u:GetAbsOrigin()):Length2D() < u:Script_GetAttackRange() - u.attack_target:GetHullRadius() then
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
	 		TargetIndex = u.attack_target:entindex(), 
	 		Queue = 0 
	 	}
		ExecuteOrderFromTable(newOrder)
		return 1
	end
	local team_id = u.at_team_id or u.team_id
	local all_unit = GameRules:GetGameModeEntity().to_be_destory_list[team_id]
	local attack_range = u:Script_GetAttackRange()
	local closest_enemy = nil
	local closest_distance = 9999

	for _,v in pairs(all_unit) do
		if v ~= nil and v:IsNull() == false and v:IsAlive() == true then
			if v.team_id ~= u.team_id and v:IsInvisible() == false then
				local d = (v:GetAbsOrigin() - u:GetAbsOrigin()):Length2D()
				if d < closest_distance and d < attack_range - v:GetHullRadius() then
					closest_enemy = v
					closest_distance = d
				end
			end
		end
	end

	if closest_enemy ~= nil then
		u.attack_target = closest_enemy
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
	 		TargetIndex = closest_enemy:entindex(), 
	 		Queue = 0 
	 	}
		ExecuteOrderFromTable(newOrder)
		return 1
	else
		u.attack_target = nil
		return nil
	end
end

function AddLoseStreak(team)
	local hero = GameRules:GetGameModeEntity().teamid2hero[team]
	if hero.lose_streak == nil then
		hero.lose_streak = 0
	end
	hero.lose_streak = hero.lose_streak + 1
end
function RemoveLoseStreak(team)
	local hero = GameRules:GetGameModeEntity().teamid2hero[team]
	hero.lose_streak = 0
end
function AddWinStreak(team)
	local hero = GameRules:GetGameModeEntity().teamid2hero[team]
	if hero.win_streak == nil then
		hero.win_streak = 0
	end
	hero.win_streak = hero.win_streak + 1

	--连胜膨胀
	local sca = (hero.init_model_scale or 1)+hero.win_streak*0.1
	if sca >= (hero.init_model_scale or 1) + 1 then
		sca = (hero.init_model_scale or 1) + 1
		--起飞！
		play_particle("particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero,3)
		local new_m = ChangeFlyingCourierModel(hero.ori_model)
		hero:SetOriginalModel(new_m)
		hero:SetModel(new_m)
		AddAbilityAndSetLevel(hero,'courier_fly')
	end
	hero:SetModelScale(sca)
	if hero.win_streak == 5 or hero.win_streak == 8 or hero.win_streak == 10 then
		CustomGameEventManager:Send_ServerToAllClients("win_streak",{
			player_id = hero:GetPlayerID(),
			streak = hero.win_streak,
		})
	end
end
function RemoveWinStreak(team)
	local hero = GameRules:GetGameModeEntity().teamid2hero[team]
	if hero ~= nil and hero.win_streak ~= nil and hero.win_streak >= 5 then
		--扎破
		ShowCombat({
			t = 'terminate',
			player = hero:GetPlayerID(),
		})
		EmitSoundOn("DOTA_Item.AbyssalBlade.Activate",hero)
		play_particle("particles/items_fx/abyssal_blade_jugger.vpcf",PATTACH_OVERHEAD_FOLLOW,hero,3)

		hero:SetOriginalModel(hero.ori_model)
		hero:SetModel(hero.ori_model)
		RemoveAbilityAndModifier(hero,'courier_fly')
	end
	hero.win_streak = 0
	hero:SetModelScale(hero.init_model_scale or 1)
end

function DAC:OnKeyboardPickChess(keys)
	if keys.team ~= nil and TeamId2Hero(keys.team) ~= nil and TeamId2Hero(keys.team).hand_entities ~= nil and TeamId2Hero(keys.team).hand_entities[keys.chess_index] ~= nil then
		-- PickChess({
		-- 	target = TeamId2Hero(keys.team).hand_entities[keys.chess_index],
		-- 	caster = TeamId2Hero(keys.team),
		-- })

		local hero = TeamId2Hero(keys.team)
		local chess = TeamId2Hero(keys.team).hand_entities[keys.chess_index]

		local newOrder = {
	 		UnitIndex = hero:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = chess:entindex(), 
	 		AbilityIndex = hero:FindAbilityByName("pick_chess"):entindex(), 
	 		Position = nil, 
	 		Queue = 0 
	 	}
		ExecuteOrderFromTable(newOrder)
	end
end

--调用寻路算法
function FindPath(p1,p2,team)
	local map = {
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0},
	}

	for u,v in pairs(GameRules:GetGameModeEntity().unit[team]) do
		local y = tonumber(string.split(u,'_')[1])
		local x = tonumber(string.split(u,'_')[2])
		if v == 1 then
			map[y][x] = 1
		end
	end

	-- Value for walkable tiles
	local walkable = 0

	-- Library setup
	local Grid = require ("pathfinder/grid") -- The grid class
	local Pathfinder = require ("pathfinder/pathfinder") -- The pathfinder lass

	-- Creates a grid object
	local grid = nil

	grid = Grid(map)
	--grid = Grid(map)

	-- Creates a pathfinder object using Jump Point Search
	local myFinder = nil
	myFinder = Pathfinder(grid, 'JPS', walkable)

	-- Define start and goal locations coordinates
	local startx, starty = Vector2X(p1,team),Vector2Y(p1,team)
	local endx, endy = Vector2X(p2,team), Vector2Y(p2,team)

	map[starty][startx] = 0

	--local startx, starty = 2,2
	--local endx, endy = 9,9

	-- Calculates the path, and its length
	local path, length = myFinder:getPath(startx, starty, endx, endy)

	if path then
		local dx = 0
		local dy = 0
		local lastx = -100
		local lasty = -100
		local lastdx = -100
		local lastdy = -100
		local lastd = -100
		local d = 0
		local pppp = {}

		for node, count in path:iter() do

			dx = node.x-lastx
			dy = node.y-lasty

			if dy==0 then
				d = 999
			else
				d = dx/dy
			end

			local lastindex = table.maxn (pppp)

			if d~=lastd or lastindex<=1 then
				table.insert (pppp, node)
			else
				pppp[lastindex] = node
			end
			lastdx = dx
			lastdy = dy
			lastx = node.x
			lasty = node.y
			lastd = d

		end

		--找到路了
		for _,node in pairs(pppp) do
			if node.x ~= startx or node.y ~= starty then
				return XY2Vector(node.x,node.y,team)
			end
		end

		return nil
	else
		-- print('find NO')
		--没找到路
		return nil
	end
end

function InitChessPool()
	local chess_pool_times = GameRules:GetGameModeEntity().CHESS_POOL_SIZE or 6
	for cost,v in pairs(GameRules:GetGameModeEntity().chess_list_by_mana) do
		for _,chess in pairs(v) do
			local chess_count = GameRules:GetGameModeEntity().CHESS_INIT_COUNT[cost]*chess_pool_times
			-- if chess == 'chess_eh' or chess == 'chess_fur' or chess == 'chess_tp' or chess == 'chess_ld' then
			-- 	chess_count = math.floor(chess_count*GameRules:GetGameModeEntity().CHESS_INIT_DRUID_PER)
			-- end
			for i=1,chess_count do
				AddAChessToChessPool(chess)
			end
		end
	end
	prt('INIT CHESS POOL OK!')
end

function DrawAChessFromChessPool(cost, table_11chess)
	if table_11chess == nil then
		table_11chess = {}
	end
	if GameRules:GetGameModeEntity().chess_pool[cost] == nil or table.maxn(GameRules:GetGameModeEntity().chess_pool[cost])<1 then
		--棋库空了
		return nil
	end
	local index = RandomInt(1,table.maxn(GameRules:GetGameModeEntity().chess_pool[cost]))
	local chess_name = GameRules:GetGameModeEntity().chess_pool[cost][index]

	if FindValueInTable(table_11chess,chess_name) == true then
		return nil
	end

	table.remove(GameRules:GetGameModeEntity().chess_pool[cost],index)
	return chess_name
end

function AddAChessToChessPool(chess)
	if string.find(chess,'ssr') then
		return
	end
	local maxcount = 1
	if string.find(chess,'11') ~= nil and (string.find(chess,'tp') ~= nil or string.find(chess,'eh') ~= nil) then
		chess = string.sub(chess,1,-2)
		maxcount = 4
	end
	if string.find(chess,'1') ~= nil and (string.find(chess,'tp') ~= nil or string.find(chess,'eh') ~= nil) then
		chess = string.sub(chess,1,-2)
		maxcount = 2
	end
	if string.find(chess,'11') ~= nil then
		chess = string.sub(chess,1,-2)
		maxcount = 9
	end
	if string.find(chess,'1') ~= nil then
		chess = string.sub(chess,1,-2)
		maxcount = 3
	end
	for count = 1,maxcount do
		if GameRules:GetGameModeEntity().chess_2_mana[chess] ~= nil and FindValueInTable(GameRules:GetGameModeEntity().chess_list_ssr,chess) == false then
			local cost = GameRules:GetGameModeEntity().chess_2_mana[chess]
			table.insert(GameRules:GetGameModeEntity().chess_pool[cost],chess)
		end
	end
end

function PrintChessPool()
	local count = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	}
	local count_all = 0

	for i=1,5 do
		count[i] = table.maxn(GameRules:GetGameModeEntity().chess_pool[i])
		count_all = count_all + count[i]
	end

	prt('棋库有'..count_all..'个棋子（'..count[1]..'/'..count[2]..'/'..count[3]..'/'..count[4]..'/'..count[5]..'）')
end

function SendHTTP(url, callback, fail_callback)
	local str0 = url
	local str1 = ''
	local str2 = ''
	local str3 = ''
	local usercheck = 0
	local x1 = string.find(str0,'@',1)
	if x1 then
		usercheck = 1
		str1 = string.sub(str0,x1+1,-1)
	else
		str1 = str0
	end
	local x2 = string.find(str1,'@',1)
	if x2 then
		str2 = string.sub(str1,0,x2-1)
	else
		str2 = str1
	end
	local x3 = string.find(str2,'?',1)
	if x3 then
		str3 = string.sub(str2,0,x3-1)
	else
		str3 = str2
	end
	if usercheck == 1 then
		local usertable = string.split(str3,',')
		for _,userid in pairs(usertable) do
			if userid then
				if not string.find(GameRules:GetGameModeEntity().steamidlist,userid,1) and not string.find(GameRules:GetGameModeEntity().steamidlist_heroindex,userid,1) then
					return
				end
			end
		end
	end
	local req = CreateHTTPRequestScriptVM('GET', url)
	req:SetHTTPRequestAbsoluteTimeoutMS(30000)

    req:Send(function(res)
        if res.StatusCode ~= 200 or not res.Body then
            -- prt('CONNECT SERVER ERROR:'..res.StatusCode)
            if fail_callback ~= nil then
            	fail_callback(obj)
            end
            return
        end

        local obj = json.decode(res.Body)
        if callback ~= nil then
        	callback(obj)
        end
    end)
end

function StatChess()
	local statinfo = {}
	for i=6,13 do
		for _,chess in pairs(GameRules:GetGameModeEntity().mychess[i]) do
			local find_name = chess.chess
			local chess_count = 1
			if string.find(chess.chess,'11') ~= nil and (string.find(chess.chess,'tp') ~= nil or string.find(chess.chess,'eh') ~= nil) then
				find_name = string.sub(chess.chess,1,-2)
				chess_count = 4
			end
			if string.find(chess.chess,'1') ~= nil and (string.find(chess.chess,'tp') ~= nil or string.find(chess.chess,'eh') ~= nil) then
				find_name = string.sub(chess.chess,1,-2)
				chess_count = 2
			end
			if string.find(chess.chess,'11') then
				chess_count = 9
				find_name = string.sub(chess.chess,1,-3)
			elseif string.find(chess.chess,'1') then
				chess_count = 3
				find_name = string.sub(chess.chess,1,-2)
			end
			if statinfo[find_name] == nil then
				statinfo[find_name] = chess_count
			else
				statinfo[find_name] = statinfo[find_name] + chess_count
			end
		end
	end
	for j=6,13 do
		local hhh = TeamId2Hero(j)
		if hhh ~= nil and hhh.hand_entities ~= nil then
			for _,ent in pairs(hhh.hand_entities) do
				local find_name = ent:GetUnitName()
				local chess_count = 1
				if string.find(ent:GetUnitName(),'11') then
					chess_count = 9
					find_name = string.sub(ent:GetUnitName(),1,-3)
				elseif string.find(ent:GetUnitName(),'1') then
					chess_count = 3
					find_name = string.sub(ent:GetUnitName(),1,-2)
				end
				if statinfo[find_name] == nil then
					statinfo[find_name] = chess_count
				else
					statinfo[find_name] = statinfo[find_name] + chess_count
				end
			end
		end
	end
	CustomNetTables:SetTableValue( "dac_table", "stat_chess", { statinfo = statinfo, hehe = RandomInt(1,1000)})
end

--辅助功能——捕捉一只螃蟹，发回pui
function DAC:OnCatchCrab(keys)
	local url = keys.url.."&key="..GetDedicatedServerKey('dac').."&from=OnCatchCrab"
	local cb = keys.cb
	if url == nil or cb == nil then
		return
	end
	local player_id = keys.player_id
	local steam_id = GameRules:GetGameModeEntity().playerid2steamid[player_id]

	if string.find(url,'ranking/add') then
		return
	end

	Timers:CreateTimer(RandomFloat(0,1),function()
		SendHTTP(url, function(t)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),'send_http_cb',{
				event = cb,
				data = json.encode(t),
				hehe = RandomInt(1,100000),
			})
		end)
    end)
end
function DAC:OnUnlockChess(keys)
	local hero = TeamId2Hero(keys.team)
	hero.chesslock = false
end
function DAC:OnLockChess(keys)
	local hero = TeamId2Hero(keys.team)
	hero.chesslock = true
end

function NecSSRScythe(keys)
	local target = keys.target
	local caster = keys.caster
	local damage = 9999

	play_particle_controlIndex("particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf",PATTACH_ABSORIGIN_FOLLOW,target,3,1)
	EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target",target)

	EmitSoundOn("necrolyte_necr_kill_10",target)

	-- --如果目标受伤 就斩杀
	-- if target:GetHealth() < target:GetMaxHealth() then
	-- 	damage = 9999
	-- end

	Timers:CreateTimer(1.5,function()
		local damageTable = {
	    	victim=target,
	    	attacker=caster,
	    	damage_type=DAMAGE_TYPE_PURE,
	    	damage=damage
	    }
	    ApplyDamage(damageTable)
	end)
end

function play_particle_controlIndex(p, pos, u, d, controlIndex)
	local pp = ParticleManager:CreateParticle(p, pos, u)
	ParticleManager:SetParticleControl(pp,1,u:GetAbsOrigin())

	Timers:CreateTimer(d,function()
		if pp ~= nil then
			ParticleManager:DestroyParticle(pp,true)
		end
	end)
end

function MakeTiny(x)
	if x:GetUnitName() == 'chess_tiny11' then
		x.part1 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/burning_stone_giant_head_level_4/burning_stone_giant_head_level_4.vmdl"})
		x.part1:FollowEntity(x,true)
		x.part2 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/burning_stone_giant_body_level_4/burning_stone_giant_body_level_4.vmdl"})
		x.part2:FollowEntity(x,true)
		x.part3 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/burning_stone_giant_right_arm_level_4/burning_stone_giant_right_arm_level_4.vmdl"})
		x.part3:FollowEntity(x,true)
		x.part4 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/burning_stone_giant_left_arm_level_4/burning_stone_giant_left_arm_level_4.vmdl"})
		x.part4:FollowEntity(x,true)
	end
	if x:GetUnitName() == 'chess_tiny1' then
		x.part1 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/scarletquarry_head_t3/scarletquarry_head_t3.vmdl"})
		x.part1:FollowEntity(x,true)
		x.part2 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/scarletquarry_armor_t2/scarletquarry_armor_t2.vmdl"})
		x.part2:FollowEntity(x,true)
		x.part3 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/scarletquarry_arms_t2/scarletquarry_arms_t2.vmdl"})
		x.part3:FollowEntity(x,true)
		x.part4 = SpawnEntityFromTableSynchronous('prop_dynamic',{model="models/items/tiny/scarletquarry_offhand_t2/scarletquarry_offhand_t2.vmdl"})
		x.part4:FollowEntity(x,true)
	end
end

function TinyTouzhi(keys)
	local p = keys.target_points[1]
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	
	
	local radius = keys.radius or 200
	local damage = keys.damage or 100
	local stun = keys.stun or 2

	local target = FindUnluckyDog190(caster)
	if target == nil then
		return
	end

	local team_id = target.at_team_id or target.team_id
	local v = FindFarthestEmptyGrid(target)
	local yy = target.y
	local xx = target.x

	local y = Vector2Y(v,team_id)
	local x = Vector2X(v,team_id)
	local stun_duration = ((v-target:GetAbsOrigin()):Length2D()/1000)

	Timers:CreateTimer(stun_duration+0.3,function()
		ApplyDamageInRadius({
			caster = caster,
			team = 2,
			radius = radius,
			role = 2,
			position = target:GetAbsOrigin(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		})
		play_particle("particles/units/heroes/hero_tiny/tiny_toss_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,target,3)
		EmitSoundOn('Ability.TossImpact',target)
	end)

	target:AddNewModifier(target,nil,"modifier_stunned",{ duration = stun_duration+stun })

	GameRules:GetGameModeEntity().unit[team_id][y..'_'..x] = 1

	BlinkChessX({p=v,caster=target})
	target.y_x = y..'_'..x
	target.y = y
	target.x = x
	GameRules:GetGameModeEntity().unit[team_id][yy..'_'..xx] = nil
end

function FindFarthestEmptyGrid(u)
	local team_id = u.at_team_id or u.team_id
	local result_postion = nil
	local length2d = 0
	for x=1,8 do
		for y=1,8 do
			local pos = XY2Vector(x,y,team_id)
			if GameRules:GetGameModeEntity().unit[team_id][y..'_'..x] == nil then
				if (u:GetAbsOrigin() - pos):Length2D() > length2d then
					result_postion = pos
					length2d = (u:GetAbsOrigin() - pos):Length2D()
				end
			end
		end
	end
	return result_postion
end
function StatusResistance(keys)
	keys.caster:AddNewModifier(keys.caster,keys.ability,"modifier_status_resistance",nil)
end

function QiquWaibiao(keys)
	local attacker = keys.attacker
	local caster = keys.caster
	local duration = keys.duration or 2

	if attacker:Script_GetAttackRange() < 250 then  
		--近战
		EmitSoundOn("Hero_Tiny.CraggyExterior",attacker)
		attacker:AddNewModifier(attacker,nil,"modifier_stunned",{ duration = duration })
		attacker:AddNewModifier(attacker,nil,"modifier_medusa_stone_gaze_stone",{ duration = duration })
	end
end

function DemonAttack(keys)
    local caster = keys.caster
    local target = keys.target

	--获取攻击伤害
    local damage = math.floor((keys.attack_damage or 0) / 2)
    local damageTable = {
    	victim=target,
    	attacker=caster,
    	damage_type=DAMAGE_TYPE_PURE,
    	damage=damage
    }
    ApplyDamage(damageTable)
end

function ChangeFlyingCourierModel(opp_model)
	local new_m = string.sub(opp_model,1,string.len(opp_model)-5)..'_flying.vmdl'
	if opp_model == "models/courier/mighty_boar/mighty_boar.vmdl" then
		new_m = "models/courier/mighty_boar/mighty_boar_wings.vmdl"
	end
	if opp_model == "models/courier/yak/yak.vmdl" then
		new_m = "models/courier/yak/yak_wings.vmdl"
	end
	if opp_model == "models/props_gameplay/donkey_dire.vmdl" then
		new_m = "models/props_gameplay/donkey_dire_wings.vmdl"
	end
	if opp_model == "models/props_gameplay/donkey.vmdl" then
		new_m = "models/props_gameplay/donkey_wings.vmdl"
	end
	if opp_model == "models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl" then
		new_m = opp_model
	end
	if opp_model == "models/items/furion/treant_flower_1.vmdl" then
		new_m = opp_model
	end
	if opp_model == "models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl" then
		new_m = opp_model
	end
	if opp_model == "models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl" then
		new_m = opp_model
	end
	if opp_model == "models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl" then
		new_m = opp_model
	end

	return new_m
end

--type = round_pve/round_pvp/combine/battle/say/notice
--text = 要显示的文字
--player = 玩家id
function ShowCombat(keys)
	local combat_type = keys.t
	local combat_text = keys.text
	local combat_num = keys.num
	local combat_player = keys.player
	local combat_player2 = keys.player2
	local gameEvent = {}

	if combat_player ~= nil then
		gameEvent["player_id"] = combat_player
	end
	if combat_player2 ~= nil then
		gameEvent["player_id2"] = combat_player2
	end
	if combat_text ~= nil then
		gameEvent["locstring_value"] = combat_text
	end
	if combat_num ~= nil then
		gameEvent["int_value"] = combat_num
	end
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#text_combat_event_"..combat_type
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

function DAC:OnChangeOndutyHero(keys)
	local player_id = keys.player_id
	local onduty_hero_new = keys.onduty_hero_new

	local onduty_hero = string.split(onduty_hero_new,'_')[1]
	local onduty_hero_effect = string.split(onduty_hero_new,'_')[2] or ''
	local onduty_hero_model = GameRules:GetGameModeEntity().sm_hero_list[onduty_hero]

	local hero = PlayerId2Hero(player_id)

	hero:SetOriginalModel(onduty_hero_model)
	hero:SetModel(onduty_hero_model)
	hero.ori_model = onduty_hero_model

	--换特效
	if hero.effect ~= nil then
		hero:RemoveAbility(hero.effect)
		hero:RemoveModifierByName('modifier_texiao_star')
	end
	hero.effect = onduty_hero_effect
	if onduty_hero_effect ~= 'e000' then
		hero:AddAbility(onduty_hero_effect)
		hero:FindAbilityByName(onduty_hero_effect):SetLevel(1)
	end

	local steam_id = hero.steam_id

	GameRules:GetGameModeEntity().stat_info[steam_id]['zhugong'] = onduty_hero
	GameRules:GetGameModeEntity().stat_info[steam_id]['zhugong_model'] = onduty_hero_model
	GameRules:GetGameModeEntity().stat_info[steam_id]['zhugong_effect'] = onduty_hero_effect
	GameRules:GetGameModeEntity().user_info[steam_id]['zhugong_model'] = onduty_hero_model
	GameRules:GetGameModeEntity().user_info[steam_id]['zhugong_effect'] = onduty_hero_effect
	GameRules:GetGameModeEntity().user_info[steam_id]['onduty_hero'] = onduty_hero
	GameRules:GetGameModeEntity().user_info[steam_id]['onduty_hero_effect'] = onduty_hero_effect

	CustomNetTables:SetTableValue( "dac_table", "player_info", { info = GameRules:GetGameModeEntity().user_info, hehe = RandomInt(1,1000)})
end
function DAC:OnPreviewEffect(keys)
	local h = EntIndexToHScript(keys.hero_index)
	if h.is_preview_cd == true then
		return
	end
	h.is_preview_cd = true
	local e = keys.effect

	if h.effect ~= nil then
		h:RemoveAbility(h.effect)
		h:RemoveModifierByName('modifier_texiao_star')
	end
	h:AddAbility(e)
	h:FindAbilityByName(e):SetLevel(1)

	Timers:CreateTimer(5,function()
		h:RemoveAbility(e)
		h:RemoveModifierByName('modifier_texiao_star')
		if h.effect ~= nil then
			h:AddAbility(h.effect)
			h:FindAbilityByName(h.effect):SetLevel(1)
		end
		Timers:CreateTimer(3,function()
			h.is_preview_cd = false
		end)
	end)
end

function SendMaxData(t,dur)
	print('------------------SendMaxData-----------------------')
	DeepPrintTable(t)
	local max_url = "http://api.maxjia.com/api/rpg/autochess/upload/?apikey=69f395b2-f7e8-4032-bd0c-41200cfe9dad"
	local max_data = {
	    key=GetDedicatedServerKey('max'),
	    version="1.0",
	    match_id=t.end_time,
	    end_time=t.end_time,
	    duration=dur,
	    players={},
	    chess_detail=GameRules:GetGameModeEntity().upload_detail_stat,
	}

	for user,data in pairs(t.mmr_info) do
	    local insertdata = {}
	    insertdata["account_id"] = user
	    insertdata["rank"] = data.rank
	    insertdata["total"] = data.total
	    insertdata["level"] = data.level
	    insertdata["chess"] = GameRules:GetGameModeEntity().stat_info[user]['chess_lineup']
	    table.insert(max_data['players'],insertdata)
	end
	DeepPrintTable(max_data)
	SendHTTPPost(max_url,max_data)
end

function SendHTTPPost(url,game_data)
    local req = CreateHTTPRequestScriptVM("POST",url.."&from=SendHTTPPost")
    -- ScoreSystemUpdateCount = ScoreSystemUpdateCount + 1
    req:SetHTTPRequestGetOrPostParameter("data",json.encode(game_data))
    req:Send(function(res)
    	DeepPrintTable(res)
        if res.StatusCode ~= 200 or not res.Body then
            return
        end
        -- local obj = json.decode(res.Body)
        -- if callback ~= nil then
        --     success_cb(obj)
        -- end
    end)
end

function DAC:OnMatchDetailsUpdated(keys)
	print("OnMatchDetailsUpdated------------------")
	for k,v in pairs(keys) do
		print(k)
	end
	DeepPrintTable(keys)
	for k,v in pairs(keys) do
		prt(k..'='..v)
	end
end