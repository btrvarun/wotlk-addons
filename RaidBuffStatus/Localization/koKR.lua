﻿local L = LibStub("AceLocale-3.0"):NewLocale("RaidBuffStatus", "koKR")
if not L then return end

-- To help with missing translations please go here:
-- http://www.wowace.com/addons/raidbuffstatus/localization/


--BuffOptionsWindow - The window opened from the top right button on the main dashboard which configures which buffs to show on the dashboard.
L["Buff Options"] = "버프 설정"
-- L["Is a buff"] = ""
-- L["Is a warning"] = ""
-- L["Report on Boss"] = ""
-- L["Report on Trash"] = ""
L["Show on dashboard"] = "대쉬보드에 보이기"
L["Show/Report in combat"] = "전투중에 보이기/보고하기"




--CrowdControlWarnings - The messages about crowd control breakage.
-- L["%s broke %s on %s%s%s"] = ""
-- L["%s broke %s on %s%s%s with %s"] = ""
L["Non-tank %s broke %s on %s%s%s"] = "비탱커 %s님이 %s를 %s%s%s로부터 해제했습니다"
L["Non-tank %s broke %s on %s%s%s with %s"] = "비탱커 %s님이 %s를 %s%s%s로부터 %s를 사용해서 해제했습니다."




--Messages -- General messages in whisper, tooltips, raid report, main dashboard buttons, etc.
L[" has set us up a Refreshment Table"] = "님이 원기 회복의 식탁을 만들었습니다"
L[" has set us up a Repair Bot"] = "님이 수리 로봇을 소환했습니다."
L[" has set us up a Soul Well"] = "님이 영혼의 샘을 만들었습니다."
L["%s cast %s on %s"] = "%s님이 %s를 %s님에게 시전합니다."
L["%s has a newer (%s) version of RBS (%s) than you (%s)"] = "%s의 RBS 버전 (%s)이 당신 (%s)보다 최신버전을 사용합니다." -- Needs review
L["%s is setting Pally Power for %s but they are not in the raid/party"] = "%s가 %의 Pally Power를 설정했으나, 그가 현재 공격대/파티에 속해있지 않습니다."
-- L["( Poison ?[IVX]*)"] = ""
L["(Earthliving)"] = "(대지생명)"
L["(Firestone)"] = "(화염석)"
L["(Flametongue)"] = "(불꽃)"
L["(Frostbrand)"] = "(냉기)"
L["(Remove buff)"] = "(버프를 제거합니다)"
L["(Rockbiter)"] = "(대지)"
L["(Spellstone)"] = "(주문석)"
-- L["(Ward of Shielding)"] = ""
L["(Windfury)"] = "(질풍)"
L["AFK"] = "자리 비움"
L["Agil"] = "민첩성"
-- L["Alt-Click on a party buff will cast on someone missing that buff."] = ""
-- L["Alt-Click on a self buff will renew that buff."] = ""
L["Aspect Cheetah/Pack On"] = "치타의 상이나 치타 무리의 상이 켜져 있습니다."
L["Aspect of the Cheetah or Pack is on"] = "치타의 상이나 치타 무리의 상이 켜져 있습니다."
L["Battle Elixir"] = "전투 비약"
L["Black Temple"] = "검은 사원"
L["Blessing of Kings, with this raid configuration, is better at least partly provided by Drums of the Forgotten Kings thus allowing other blessings to be used."] = "현재 레이드 구성상, 잊혀진 왕의 북이 왕의 축복보다 부분적으로 좋은 성능을 제공합니다. 따라서, 다른 축복을 사용하세요."
L["Blessing of Wisdom will be overwritten by Shaman totems as points spent in Restorative Totems is greater than Improved Blessing of Wisdom."] = "연마한 지혜의 축복보다 특성 포인트를 더 사용한 회복에 토템에 의해서 지혜의 축복이 사라지게 될 것입니다."
L["BoK"] = "왕축"
L["BoM"] = "힘축"
L["BoS"] = "성축"
L["BoW"] = "지축"
L["Boss"] = "보스"
L["Buffers: "] = "버프 가능자:"
-- L["Cast by:"] = ""
-- L["Check Pally Power for: "] = ""
L["Click buffs to disable and enable."] = "클릭하시면 버프의 사용 여부를 토글합니다."
L["Click to toggle the RBS dashboard"] = "클릭 버프 확인창 보기 전환"
-- L["Ctrl-Click Boss or Trash to whisper all those who need to buff."] = ""
L["Ctrl-Click buffs to whisper those who need to buff."] = "버프를 컨트롤 클릭하면 그 버프가 필요한 사람에게 귓속말을 합니다."
L["Dead"] = "죽음"
L["Death Knight Aura"] = "죽음의 기사 형상"
-- L["Death Knight Presence"] = ""
L["Death Knight is missing an Aura"] = "죽음의 기사의 형상이 없습니다"
L["Different Zone"] = "다른 지역"
L["Fish Feast about to expire!"] = "생선 통구이가 사라지려고 합니다!"
L["Flask or two Elixirs"] = "영약 또는 비약 2종"
-- L["Flasked or Elixired but slacking"] = ""
-- L["Got"] = ""
L["Gruul's Lair"] = "그룰의 둥지"
L["Guardian Elixir"] = "강화 비약"
L["Has buff: "] = "가지고 있는 버프 : "
L["Healer %s has died!"] = "힐러 %s 가 죽었습니다!"
L["Health less than 80%"] = "체력이 80% 이하"
L["Hunter Aspect"] = "사냥꾼 상"
L["Hunter has no aspect at all"] = "사냥꾼이 어떤 상도 켜지 않았습니다."
L["Hyjal Summit"] = "하이잘 전투"
L["Int"] = "지능"
L["Item count: "] = "아이템 수:"
L["Low durability"] = "내구도 낮음"
L["Low durability (35% or less)"] = "내구도 낮음 (35% 이하)"
-- L["MANY!"] = ""
-- L["Mage is missing a Mage Armor"] = ""
L["Mana less than 80%"] = "마나가 80% 이하"
L["Melee DPS %s has died!"] = "근접 딜러 %s 가 죽었습니다!"
L["Missing "] = "없는 버프 :"
L["Missing Vigilance"] = "경계 없음"
L["Missing a Battle Elixir"] = "전투 비약 없음"
L["Missing a Flask or two Elixirs"] = "영약 또는 비약2종 없음"
L["Missing a Guardian Elixir"] = "강화 비약 없음"
-- L["Missing a scroll"] = ""
L["Missing a temporary weapon buff"] = "임시 무기 버프 없음"
L["Missing buff: "] = "부족한 버프 : "
L["Missing buffs (Boss): "] = "부족한 버프 (보스) : "
-- L["Missing buffs (Trash): "] = ""
L["Missing or not working oRA: "] = "oRA2를 사용하지 않음" -- Needs review
L["No"] = "아니오"
L["No Soulstone detected"] = "영혼석이 발견되지 않았습니다."
-- L["No buffs needed! (Boss)"] = ""
-- L["No buffs needed! (Trash)"] = ""
L["Not Well Fed"] = "포만감 버프 부족"
L["Offline"] = "오프라인"
L["Out of range"] = "사거리 밖"
-- L["PVP On"] = ""
-- L["PVP is On"] = ""
-- L["Paladin %s has left the raid and had Pally Power blessings assigned to them"] = ""
L["Paladin Aura"] = "성기사 오라"
-- L["Paladin Different Aura - Group"] = ""
L["Paladin blessing"] = "성기사 축복"
L["Paladin has Crusader Aura"] = "성기사가 성전사 오라를 켜고 있습니다"
L["Paladin has Shadow Resistance Aura AND Shadow Protection"] = "성기사가 암흑 저항의 오라와 암흑 보호의 기원 효과를 모두 가지고 있습니다."
L["Paladin has no Aura at all"] = "성기사가 어떤 오라도 가지지 않았습니다."
L["Paladin missing Seal"] = "문장을 켜지 않은 성기사"
L["Paladins missing Pally Power: "] = "Pally Power를 사용하지 않는 성기사"
L["Pally Power missing: "] = "Pally Power를 사용하지 않습니다."
L["Player has a wrong Paladin blessing"] = "플레이어가 잘못된 성기사 축복을 받았습니다."
L["Player has health less than 80%"] = "플레이어의 체력이 80% 이하입니다."
L["Player has mana less than 80%"] = "플레이어의 마나가 80% 이하입니다."
L["Player is AFK"] = "플레이어가 자리비움 상태입니다."
L["Player is Dead"] = "플레이어가 죽었습니다."
L["Player is Offline"] = "플레이어가 오프라인입니다."
L["Player is in a different zone"] = "플레이어가 다른 지역에 있습니다."
L["Player is missing at least one Paladin blessing"] = "플레이어가 적어도 하나 이상의 성기사 축복이 부족합니다."
-- L["Please relog or reload UI to update the item cache."] = ""
L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."] = "ESC -> 인터페이스 설정 -> 애드온 -> RaidBuffStatus에서 추가설정을 하세요."
L["Prot"] = "보호의 두루마리"
L["Protection Paladin with no Righteous Fury"] = "정의의 격노를 켜지 않은 보호기사"
L["R"] = "R"
L["RBS Dashboard Help"] = "RBS 대쉬보드 도움말"
L["RBS Tank List"] = "RBS 탱커 목록"
L["Ranged DPS %s has died!"] = "원거리 딜러 %s 가 죽었습니다!"
L["Refreshment Table about to expire!"] = "원기 회복의 식탁이 사라지려고 합니다!"
L["Remind me later"] = "추후에 알려주세요"
L["Remove this button from this dashboard in the buff options window."] = "버프 옵션창에 있는 대쉬보드에서 이 버튼을 삭제합니다."
L["Repair Bot about to expire!"] = "수리 로봇이 곧 사라집니다!"
L["Right-click to open the addons options menu"] = "애드온 옵션 메뉴를 열려면 우클릭하세요."
L["Sanctuary is assigned in Pally Power but no one has the spec to do it."] = "Pally Power에서 성축이 설정되었으나, 성축 시전이 가능한 성기사가 없습니다."
L["Scan"] = "검사"
L["Scroll"] = "두루마리"
L["Seal"] = "문장"
-- L["Serpentshrine Cavern"] = ""
L["Shadow Resistance Aura AND Shadow Protection"] = "암흑 저항의 오라와 암흑 보호"
-- L["Shift-Click buffs to report on only that buff."] = ""
-- L["Slackers: "] = ""
-- L["Slacking Paladins"] = ""
-- L["Someone has a Soulstone or not"] = ""
L["Soul Well about to expire!"] = "영혼의 샘이 곧 사라집니다!"
L["Spi"] = "정신력"
L["Sta"] = "체력"
L["Stamina increased by 40"] = "체력 40만큼 증가"
L["Str"] = "힘"
-- L["Sunwell Plateau"] = ""
L["Tank %s has died!"] = "탱커 %s 가 죽었습니다!"
L["Tank missing Earth Shield"] = "대지의 보호막이 없는 탱커"
L["Tank missing Thorns"] = "가시가 없는 탱커"
-- L["Tank with "] = ""
-- L["Tempest Keep"] = ""
-- L["The above default button actions can be reconfigured."] = ""
-- L["The following have inappropriate Paladin blessings: "] = ""
L["There are more Paladins than different Auras in group"] = "같은 오라를 켜거나, 오라를 켜지 않은 성기사가 있습니다."
L["This is the first time RaidBuffStatus has been activated since installation or settings were reset. Would you like to visit the Buff Wizard to help you get RBS buffs configured? If you are a raid leader then you can click No as the defaults are already set up for you."] = "RaidBuffStatus의 최초 사용입니다. RBS의 버프 설정을 돕기 위해서 버프 마법사를 실행하시겠습니까? 만일 공격대장이라면 당신에게 맞는 기본 옵션을 사용하기 위해서 No를 클릭하세요."
-- L["Trash"] = ""
L["Warning: "] = "경고:"
L["Warnings: "] = "경고:"
L["Weapon buff"] = "무기 버프"
-- L["Well Fed but slacking"] = ""
-- L["Wintergrasp"] = ""
L["Wrong Paladin blessing"] = "잘못된 성기사 축복"
-- L["Wrong flask for this zone"] = ""
L["You need to be leader or assistant to do this"] = "이것을 수행하기 위해서는 공대장이나 승급이 된 사람이어야 합니다."
L["[IMMUNE]"] = "[면역]"
L["[RESIST]"] = "[저항]"
-- L["alpha"] = ""
-- L["beta"] = ""
-- L["expecting"] = ""
L["prepares a Fish Feast!"] = "님이 생선 통구이를 준비합니다!"




--Options - Command line and standard Blizzard addon interface options.
L["Alive"] = "생존자"
L["Allow raiders to use level 70 TBC flasks and elixirs"] = "70레벨 불타는 성전 비약 및 영약 허용"
L["Allow raiders to use level 70 TBC flasks and elixirs that are just as good as WotLK flasks and elixirs"] = "리치왕의 분노 비약이나 영약 급의 레벨 70인 불타는 성전 비약 또는 영약 허용"
L["Alt-left click"] = "Alt-좌클릭"
L["Alt-right click"] = "Alt-우클릭"
-- L["Always hide the Boss R Trash buttons"] = ""
L["Announce to raid warning when a Fish Feast is prepared"] = "생선 통구이가 준비 되었을 때 공격대 경보로 알려주기"
L["Announce to raid warning when a Refreshment Table is prepared"] = "원기 회복의 식탁이 준비되었을 때 공격대 경보로 알리기"
L["Announce to raid warning when a Repair Bot is prepared"] = "수리 로봇 준비 시 공격대 경보로 알림"
L["Announce to raid warning when a Soul Well is prepared"] = "원기 회복의 식탁이 준비되었을 때 공격대 경보로 알려주기"
L["Anti spam"] = "스팸 방지"
L["Appearance"] = "외형"
-- L["Automatically configures the dashboard buffs and configuration defaults for your class or raid leading role"] = ""
L["Automatically show the dashboard when you join a battleground"] = "전장 참여시 자동으로 확인창 보기"
L["Automatically show the dashboard when you join a party"] = "파티 참여 시 자동으로 확인창 보기"
L["Automatically show the dashboard when you join a raid"] = "공격대 참여 시 자동으로 확인창 보기"
L["Automatically whisper anyone missing Well Fed when your Fish Feast expire warnings appear"] = "생선 통구이가 사라진다는 경고가 나타났을 때, 포만감 버프가 없는 플레이어에게 자동적으로 귓속말을 전송합니다"
L["Automatically whisper anyone missing a Healthstone when your Soul Well expire warnings appear"] = "영혼의 샘이 사라진다는 경고를 할 때 생명석을 가지고 있지 않은 사람에게 자동으로 귓속말을 합니다."
L["Background colour"] = "배경색"
L["Border colour"] = "외곽선 색"
-- L["Bosses only"] = ""
L["Buff Wizard"] = "버프 마법사"
-- L["Buff those missing buff"] = ""
L["CC-break warnings"] = "군중제어 해제 경고"
L["Combat"] = "전투"
L["Combat options"] = "전투 설정"
L["Consumable options"] = "소비용품 설정"
-- L["Core raid buffs"] = ""
L["Ctrl-left click"] = "Ctrl-좌클릭"
L["Ctrl-right click"] = "Ctrl-우클릭"
L["DPS mana"] = "딜러 마나"
-- L["Danielbarron broke Sheep on The Lich King with Hand of Reckoning"] = ""
-- L["Darinia ninjaed my target (The Lich King) with Taunt"] = ""
-- L["Darinia taunted my mob (The Lich King) with Taunt"] = ""
-- L["Darinia taunted my target (The Lich King) with Taunt"] = ""
L["Dashboard columns"] = "확인창 칸 수"
L["Dashboard mouse button actions options"] = "확인창 마우스 버튼 설정"
L["Death warnings"] = "죽음 경고"
-- L["Disable scan in combat"] = ""
-- L["Dumb assignment"] = ""
-- L["Enable tank warnings including taunts, failed taunts and mob stealing"] = ""
-- L["Enable tank warnings including taunts, failed taunts and mob stealing only on bosses"] = ""
L["Enable warning messages when players die"] = "플레이어가 죽었을때 경고 메세지를 사용합니다."
L["Enable warnings when Crowd Control is broken by tanks and non-tanks"] = "탱커나 비탱커에 의해서 군중제어가 해제됐을때 경고를 사용"
L["Enable warnings when Misdirection or Tricks of the Trade is cast"] = "눈속임이나 속임수 거래가 시전되었을 때 경보를 가능하도록 합니다"
L["Enable/disable buff check"] = "버프 체크 사용/미사용"
L["Feast auto whisper"] = "생선 통구이 자동 귓말"
L["Fish Feast"] = "생선 통구이"
L["Food announce"] = "음식 알림"
L["Food raid warning announcement options for things like Fish Feasts"] = "생선 통구이 같은 공격대용 음식에 대한 경고 옵션"
L["Good TBC"] = "불타는 성전 허용"
L["Good food only"] = "최고 등급 음식만 허용"
L["Healer Stormsnow has died!"] = "힐러 Stormsnow가 죽었습니다!"
L["Healer death"] = "힐러 사망"
L["Healer mana"] = "힐러 마나"
L["Healers alive"] = "생존한 힐러"
-- L["Hide Boss R Trash"] = ""
-- L["Hide and show the buff report dashboard."] = ""
L["Hide dashboard during combat"] = "전투동안에 대쉬보드를 숨깁니다"
L["Hide in combat"] = "전투중에 숨기기"
-- L["Hide the buff report dashboard."] = ""
L["Highlight my buffs"] = "내 버프 강조"
-- L["Hightlight currently missing buffs on the dashboard for which you are responsible including self buffs and buffs which you are missing that are provided by someone else. I.e. show buffs for which you must take action"] = ""
-- L["How MANY?"] = ""
-- L["If Pally Power is detected then use that for working out who has not buffed, i.e. which Paladins are slacking"] = ""
-- L["If a Paladin is missing Pally Power then fall back to not using Pally Power"] = ""
L["Ignore groups 6 to 8"] = "파티 6 - 8 무시"
-- L["Ignore groups 6 to 8 when reporting as these are for subs"] = ""
L["In range"] = "사거리 안"
-- L["Just check buffs as Pally Power has assigned them and don't complain when something is sub-optimal"] = ""
L["Just my buffs"] = "내 버프만 설정"
L["Left click"] = "좌클릭"
L["Melee DPS Danielbarron has died!"] = "근접 딜러 Danielbarron이 죽었습니다!"
L["Melee DPS death"] = "밀리 딜러 사망"
L["Minimap icon"] = "미니맵 아이콘"
L["Misdirection warnings"] = "눈속임 경고"
L["Mouse buttons"] = "마우스 버튼"
L["Move with Alt-click"] = "알트 클릭으로 이동"
-- L["NON-TANK Tanagra taunted my target (The Lich King) with Growl"] = ""
-- L["Ninja taunts"] = ""
-- L["Non-tank Glamor broke Hex on The Lich King with Moonfire"] = ""
L["Non-tank breaks CC"] = "비탱커가 군중제어를 해제했습니다."
-- L["Non-tank taunts my target"] = ""
-- L["None"] = ""
L["Number of columns to display on the dashboard"] = "대쉬보드에 표시할 열의 수"
-- L["Only allow food that is 40 Stamina and other stats.  I.e. only allow the top quality food with highest stats"] = ""
-- L["Only if all have it"] = ""
-- L["Only me"] = ""
-- L["Only show the buffs for which your class is responsible for.  This configuration can be used like a buff-bot where one simply right clicks on the buffs to cast them"] = ""
-- L["Only show the core class raid buffs"] = ""
-- L["Only show when you and only you break Crowd Control so you can say 'Now I don't believe you wanted to do that did you, ehee?'"] = ""
-- L["Only use tank list"] = ""
-- L["Only use the tank list and ignore spec when there is a tank list for determining if someone is a tank or not"] = ""
-- L["Options for setting the quality requirements of consumables"] = ""
L["Options for the integration of Pally Power"] = "Pally Power 통합을 위한 설정"
-- L["Options to do with configuring the tank list"] = ""
-- L["Other taunt fails"] = ""
L["Pally Power"] = "Pally Power"
L["Play a sound"] = "소리를 재생합니다."
L["Play a sound when Misdirection or Tricks of the Trade is cast"] = "눈속임이나 속임수 거래가 시전되면 소리를 재생합니다."
L["Play a sound when a healer dies"] = "힐러가 죽었을 때 소리를 재생합니다"
L["Play a sound when a melee DPS dies"] = "근접 딜러가 죽었을 때 소리를 재생합니다"
-- L["Play a sound when a non-tank breaks Crowd Control"] = ""
L["Play a sound when a ranged DPS dies"] = "원거리 딜러 죽음 시 소리 출력"
L["Play a sound when a tank breaks Crowd Control"] = "탱커가 군중 제어를 해제했을 때 소리를 재생합니다"
L["Play a sound when a tank dies"] = "탱커가 죽었을 때 소리를 재생합니다"
-- L["Play a sound when one of your taunts fails due to resist"] = ""
L["Play a sound when one of your taunts fails due to the target being immune"] = "당신이 사용한 도발이 한번이라도 실패한다면 소리를 재생합니다."
-- L["Play a sound when other people's taunts to your target fail"] = ""
-- L["Play a sound when someone else targets a mob and taunts that mob which is targeting you"] = ""
-- L["Play a sound when someone else taunts your target"] = ""
-- L["Play a sound when someone else taunts your target which is targeting you"] = ""
-- L["Play a sound when someone else who is not a tank taunts your target"] = ""
-- L["Prepend RBS::"] = ""
-- L["Prepend RBS:: to all lines of report chat. Disable to only prepend on the first line of a report"] = ""
L["Raid Status Bars"] = "레이드 상태 바"
L["Raid health"] = "공격대 체력"
L["Raid leader"] = "공격대장"
L["Raid mana"] = "공격대 마나"
L["Ranged DPS Garmann has died!"] = "원거리 딜러 Garmann이 죽었습니다!"
L["Ranged DPS death"] = "원거리 딜러 사망"
L["Refreshment Table"] = "원기 회복의 식탁"
L["Repair Bot"] = "수리 로봇"
-- L["Report missing to raid"] = ""
-- L["Report to /raid or /party who is not buffed to the max."] = ""
L["Report to officer channel"] = "관리자 채널에 보고"
L["Report to officers"] = "관리자에게 보고"
L["Report to raid/party"] = "공격대/파티에 보고"
-- L["Report to raid/party - requires raid assistant"] = ""
L["Report to self"] = "자신에게 보고"
L["Reporting"] = "보고"
L["Reporting options"] = "보고 설정"
-- L["Require the Alt buton to be held down to move the dashboard window"] = ""
L["Right click"] = "우클릭"
L["Seconds between updates"] = "업데이트 간격"
-- L["Select which action to take when you click with the left mouse button over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the left mouse button with Alt held down over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the left mouse button with Ctrl held down over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the left mouse button with Shift held down over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the right mouse button over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the right mouse button with Alt held down over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the right mouse button with Ctrl held down over a dashboard buff check"] = ""
-- L["Select which action to take when you click with the right mouse button with Shift held down over a dashboard buff check"] = ""
-- L["Set N - the number of people missing a buff considered to be \"MANY\". This also affects reagent buffing"] = ""
L["Set how many seconds between dashboard raid scan updates"] = "dashboard 레이드 스캔의 업데이트 주기를 설정합니다"
L["Shift-left click"] = "쉬프트 좌클릭"
L["Shift-right click"] = "쉬프트 우클릭"
L["Short missing blessing"] = "짧게 표시한 부족한 축복"
L["Shorten names"] = "짧게 표시한 이름"
L["Shorten names in the report to reduce channel spam"] = "채널에 스팸을 줄이기 위해서 보고시 이름을 짧게 합니다"
L["Show group number"] = "파티 이름표 보이기"
L["Show in battleground"] = "전장에서 보이기"
L["Show in party"] = "파티에 보이기"
L["Show in raid"] = "공격대에 보이기"
-- L["Show the buff report dashboard."] = ""
L["Show the group number of the person missing a party/raid buff"] = "파티/레이드 버프가 부족한 플레이어의 파티 이름표 보이기"
L["Skin and minimap options"] = "스킨과 미니맵 옵션"
L["Skip buff checking during combat. You can manually initiate a scan by pressing Scan on the dashboard"] = "전투동안에 버프 체크를 하지 않습니다. 당신은 이것을 대쉬보드의 검사 버튼을 누름으로써, 체크를 초기화할 수 있습니다."
L["Soul Well"] = "영혼의 샘"
L["Status bars to show raid, dps, tank health, mana, etc"] = "공격대, DPS, 탱커 체력, 마나 등을 보이는 상태 바"
L["TBC flasks and elixirs"] = "불타는 서전 영약 및 비약"
L["Tank Danielbarron has died!"] = "탱커 Danielbarron이 죽었습니다!"
L["Tank breaks CC"] = "탱커가 군중제어를 해제했습니다."
L["Tank death"] = "탱커 사망"
L["Tank health"] = "탱커 체력"
L["Tank list"] = "탱커 목록"
-- L["Tank warnings"] = ""
-- L["Tank warnings about taunts, failed taunts and mob stealing including accidental taunts from non-tanks"] = ""
L["Tanks alive"] = "생존한 탱커"
-- L["Taunts to my mobs"] = ""
-- L["Taunts to my target"] = ""
L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"] = "당신의 파티나 공격대 혹은 길드의 플레이어가 새 버전의 RBS가 있는지 알려줍니다"
L["Test"] = "테스트"
-- L["Test what the warning is like"] = ""
-- L["The Buff Wizard automatically configures the dashboard buffs and configuration defaults for your class or raid leading role."] = ""
L["The average DPS mana percent"] = "평균 딜러 마나 비율"
L["The average healer mana percent"] = "평균 힐러 마나 비율"
L["The average party/raid health percent"] = "평균 파티/공격대 생명력 비율"
L["The average party/raid mana percent"] = "평균 파티/공격대 마나 비율"
L["The average tank health percent"] = "평균 탱커 생명력 비율"
L["The percentage of healers alive in the raid"] = "공격대에서 생존한 힐러의 퍼센트"
L["The percentage of people alive in the raid"] = "공격대에서 생존한 플레이어의 퍼센트"
L["The percentage of people dead in the raid"] = "공격대에서 죽은 공격대원의 퍼센트"
-- L["The percentage of people within 40 yards range"] = ""
L["The percentage of tanks alive in the raid"] = "공격대에서 생존한 탱커의 퍼센트"
-- L["This is the default configuration in which RBS ships out-of-the-box.  It gives you pretty much anything a raid leader would need to see on the dashboard"] = ""
L["Toggle to display a minimap icon"] = "미니맵 아이콘 보이기를 토글합니다."
L["Use Pally Power"] = "Pally Power 사용"
L["Version announce"] = "버전 알림"
-- L["Wait before announcing to see if others have announced first in order to reduce spam"] = ""
L["Warn to party"] = "파티에 알림"
L["Warn to party when a healer dies"] = "힐러가 죽었을 때 파티에 알림"
L["Warn to party when a melee DPS dies"] = "밀리 딜러가 죽었을 때 파티에 알림"
L["Warn to party when a non-tank breaks Crowd Control"] = "비 탱커가 군중 제어를 해제했을때 파티에 경고"
L["Warn to party when a ranged DPS dies"] = "원거리 딜러 죽음시 파티에 알림"
L["Warn to party when a tank breaks Crowd Control"] = "탱커가 군중제어를 해제했을때 파티에 경고"
L["Warn to party when a tank dies"] = "탱커가 죽었을 때 파티에 알림"
-- L["Warn to party when one of your taunts fails due to resist"] = ""
-- L["Warn to party when one of your taunts fails due to the target being immune"] = ""
-- L["Warn to party when other people's taunts to your target fail"] = ""
-- L["Warn to party when someone else targets a mob and taunts that mob which is targeting you"] = ""
-- L["Warn to party when someone else taunts your target"] = ""
-- L["Warn to party when someone else taunts your target which is targeting you"] = ""
-- L["Warn to party when someone else who is not a tank taunts your target"] = ""
L["Warn to raid chat"] = "공격대창으로 알림"
L["Warn to raid chat when a healer dies"] = "힐러가 죽으면 공격대창으로 경고"
L["Warn to raid chat when a melee DPS dies"] = "밀리 딜러가 죽으면 공격대 창으로 경고"
L["Warn to raid chat when a non-tank breaks Crowd Control"] = "비탱커가 군중제어를 해제했을 때, 공격대 챗으로 경고"
L["Warn to raid chat when a ranged DPS dies"] = "원거리 딜러 죽음 시 공격대에 알림"
L["Warn to raid chat when a tank breaks Crowd Control"] = "탱커가 군중 제어 효과 해제 시 공격대에 알림"
L["Warn to raid chat when a tank dies"] = "탱커가 죽으면 공격대창으로 경고"
-- L["Warn to raid chat when one of your taunts fails due to resist"] = ""
-- L["Warn to raid chat when one of your taunts fails due to the target being immune"] = ""
-- L["Warn to raid chat when other people's taunts to your target fail"] = ""
-- L["Warn to raid chat when someone else targets a mob and taunts that mob which is targeting you"] = ""
L["Warn to raid chat when someone else taunts your target"] = "누군가가 대상을 도발 시 공격대에 알림"
-- L["Warn to raid chat when someone else taunts your target which is targeting you"] = ""
L["Warn to raid chat when someone else who is not a tank taunts your target"] = "비탱커가 대상 도발 시 공격대에 알림"
L["Warn to raid warning"] = "공격대 경보로 알림"
L["Warn to self"] = "자신에게 알림"
L["Warn to self when Misdirection or Tricks of the Trade is cast"] = "눈속임이나 속임수 거래가 시전되면 경고합니다."
L["Warn to self when a healer dies"] = "힐러가 죽었을 때 자신에게 경고합니다."
L["Warn to self when a melee DPS dies"] = "근접 딜러가 죽으면 자신에게 경고"
L["Warn to self when a non-tank breaks Crowd Control"] = "비탱커가 군중 제어 효과 해제 시 자신에게 알림"
L["Warn to self when a ranged DPS dies"] = "원거리 딜러 죽음 시 자신에게 알림"
-- L["Warn to self when a tank breaks Crowd Control"] = ""
L["Warn to self when a tank dies"] = "탱커가 죽었을 때 자신에게 알림"
-- L["Warn to self when one of your taunts fails due to resist"] = ""
-- L["Warn to self when one of your taunts fails due to the target being immune"] = ""
-- L["Warn to self when other people's taunts to your target fail"] = ""
-- L["Warn to self when someone else targets a mob and taunts that mob which is targeting you"] = ""
-- L["Warn to self when someone else taunts your target"] = ""
-- L["Warn to self when someone else taunts your target which is targeting you"] = ""
-- L["Warn to self when someone else who is not a tank taunts your target"] = ""
L["Warn using raid warning when a healer dies"] = "힐러가 죽었을 때 공격대 경보를 이용하여 알림"
L["Warn using raid warning when a melee DPS dies"] = "근접 딜러가 죽으면 공격대 경보로 경고"
L["Warn using raid warning when a non-tank breaks Crowd Control"] = "탱커가 아닌 사람이 군중제어를 해제했을 때 공격대 경보로 경고"
L["Warn using raid warning when a ranged DPS dies"] = "원거리 딜러 죽음 시 공격대 경보로 알림"
-- L["Warn using raid warning when a tank breaks Crowd Control"] = ""
L["Warn using raid warning when a tank dies"] = "탱커가 죽었을 때 공격대 경보를 사용하여 알림"
-- L["Warn using raid warning when one of your taunts fails due to resist"] = ""
-- L["Warn using raid warning when one of your taunts fails due to the target being immune"] = ""
-- L["Warn using raid warning when other people's taunts to your target fail"] = ""
-- L["Warn using raid warning when someone else targets a mob and taunts that mob which is targeting you"] = ""
L["Warn using raid warning when someone else taunts your target"] = "다른 사람이 당신의 대상을 도발했을 때 공격대 경보로 알림"
-- L["Warn using raid warning when someone else taunts your target which is targeting you"] = ""
-- L["Warn using raid warning when someone else who is not a tank taunts your target"] = ""
L["Warn when a healer dies"] = "힐러가 죽었을 때 알림"
L["Warn when a melee DPS dies"] = "밀리 딜러가 죽었을 때 알림"
L["Warn when a ranged DPS dies"] = "원거리 딜러 죽음 시 알림"
L["Warn when a tank dies"] = "탱커가 죽었을 때 알림"
L["Warning messages when players die"] = "플레이어가 죽었을 때 경보 메세지"
-- L["Warnings when Crowd Control is broken by tanks and non-tanks"] = ""
L["Warnings when Misdirection or Tricks of the Trade is cast"] = "눈속임이나 속임수 거래가 시전되면 경고"
-- L["Warnings when someone else targets a mob and taunts that mob which is targeting you"] = ""
L["Warnings when someone else taunts your target"] = "다른 사람이 당신의 대상을 도발했을 때 알림"
-- L["Warnings when someone else taunts your target who is not a tank"] = ""
L["Warns when a non-tank breaks Crowd Control"] = "비 탱커가 군중제어를 해제하면 경고"
L["Warns when a tank breaks Crowd Control"] = "탱커가 군중제어를 해제했을 때 경고합니다."
-- L["Warns when other people's taunts to your target fail"] = ""
-- L["Warns when someone else taunts your target which is targeting you"] = ""
-- L["Warns when your taunts fail due to resist"] = ""
-- L["Warns when your taunts fail due to the target being immune"] = ""
L["Well auto whisper"] = "영혼의 샘 자동 귓말"
-- L["When at least N people are missing a raid buff say MANY instead of spamming a list"] = ""
-- L["When many say so"] = ""
L["When showing the names of the missing Paladin blessings, show them in short form"] = "부족한 성기사의 축복을 표시할때, 짧은 이름을 사용합니다."
-- L["When there are multiple people who can provide a missing buff such as Fortitude then only whisper one of them at random who is in range rather than all of them"] = ""
-- L["When whispering and at least N people are missing a raid buff say MANY instead of spamming a list"] = ""
-- L["Whisper buffers"] = ""
-- L["Whisper many"] = ""
-- L["Whisper only one"] = ""
-- L["Your taunt immune-fails"] = ""
-- L["Your taunt resist-fails"] = ""
-- L["[IMMUNE] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"] = ""
-- L["[RESIST] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"] = ""
-- L["[RESIST] Darinia FAILED TO TAUNT my target (The Lich King) with Taunt"] = ""




--RaidStatusBars - The bars showing alive/mana/etc on the main dashboard.
L["Dead healers"] = "죽은 힐러"
L["Dead tanks"] = "죽은 탱커"
L["I see dead people"] = "죽은 공대원"
L["n/a"] = "n/a"




--TalentsWindow - Messages and buttons in the talents window which is the window opened by clicking top left button on the dashboard.
L["Affliction"] = "고통"
L["Arcane"] = "비전"
L["Arms"] = "무기"
L["Assassination"] = "암살"
L["Balance"] = "조화"
L["Beast Mastery"] = "야수"
L["Blood"] = "혈기"
L["Class"] = "직업"
L["Combat"] = "전투"
L["Demonology"] = "악마"
L["Destruction"] = "파괴"
L["Discipline"] = "수양"
L["Dual wield"] = "쌍수 무기"
L["Elemental"] = "정기"
L["Enhancement"] = "고양"
L["Feral Combat"] = "야성"
L["Fire"] = "화염"
L["Frost"] = "냉기"
L["Fury"] = "분노"
L["Has Aura Mastery"] = "오라 숙련"
L["Healer"] = "힐러"
L["Holy"] = "신성"
L["Hybrid"] = "하이브리드"
L["Improved Health Stone level 1"] = "생명석 연마 (1단계)" -- Needs review
L["Improved Health Stone level 2"] = "생명석 연마 (2단계)" -- Needs review
L["Marksmanship"] = "사격"
L["Melee DPS"] = "근접 딜러"
L["Name"] = "이름"
L["Protection"] = "보호"
L["Ranged DPS"] = "원거리 딜러"
L["Refresh"] = "새로고침"
L["Restoration"] = "복원"
L["Retribution"] = "징벌"
L["Role"] = "역할"
L["Shadow"] = "암흑"
-- L["Spec"] = ""
-- L["Specialisations"] = ""
L["Subtlety"] = "잠행"
L["Survival"] = "생존"
-- L["Talent Specialisations"] = ""
L["Tank"] = "탱커"
L["Unholy"] = "부정"




--TankTauntWarnings - The messages about tank taunts.
-- L["%s FAILED TO NINJA my boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO NINJA my target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT my boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT my target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT their boss target (%s%s%s) with %s"] = ""
-- L["%s FAILED TO TAUNT their target (%s%s%s) with %s"] = ""
-- L["%s ninjaed my boss target (%s%s%s) with %s"] = ""
-- L["%s ninjaed my target (%s%s%s) with %s"] = ""
-- L["%s taunted my boss mob (%s%s%s) with %s"] = ""
-- L["%s taunted my boss target (%s%s%s) with %s"] = ""
-- L["%s taunted my mob (%s%s%s) with %s"] = ""
-- L["%s taunted my target (%s%s%s) with %s"] = ""
-- L["NON-TANK %s taunted my boss target (%s%s%s) with %s"] = ""
-- L["NON-TANK %s taunted my target (%s%s%s) with %s"] = ""
