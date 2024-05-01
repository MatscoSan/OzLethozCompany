local
	NoBomb=false|NoBomb
 in
	config(bombLatency:3
	   walls:true
	   step: 0
	   spaceships: [
			spaceship(team:brown name:jason
			  positions: [pos(x:4 y:3 to:east) pos(x:3 y:3 to:east) pos(x:2 y:3 to:east)]
			  effects: nil
			  strategy: keyboard(left:'Left' right:'Right' intro:nil)
			  seismicCharge: NoBomb
			 )
			spaceship(team:green name:steve
			  positions: [pos(x:19 y:20 to:west) pos(x:20 y:20 to:west) pos(x:21 y:20 to:west)]
			  effects: nil
			  strategy:  keyboard(left:q right:d intro:nil)
			  seismicCharge: NoBomb
			 )
		   ]
		bonuses: [
			bonus(position:pos(x:5 y:3) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:8 y:14) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:4 y:16) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:15 y:12) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:18 y:12) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:12 y:15) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:17 y:3) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:15 y:4) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:18 y:4) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:18 y:17) color:black   effect:dropSeismicCharge(true|false|true|false|true|NoBomb) target:catcher)
			bonus(position:pos(x:5 y:12) color:purple   effect:shrink target:catcher)
			bonus(position:pos(x:17 y:2) color:blue   effect:bigscrap target:catcher)
			bonus(position:pos(x:4 y:8) color:orange  effect:scrap target:catcher)
			bonus(position:pos(x:7 y:15) color:orange  effect:scrap target:catcher)
			bonus(position:pos(x:12 y:7) color:orange  effect:scrap target:catcher)
			bonus(position:pos(x:15 y:7) color:yellow effect:wormhole(x:6 y:16) target:catcher)
			bonus(position:pos(x:6 y:16) color:yellow effect:wormhole(x:15 y:7) target:catcher)
			bonus(position:pos(x:14 y:14) color:red    effect:revert target:catcher)
			bonus(position:pos(x:13 y:13) color:green    effect:revert target:all)
			bonus(position:pos(x:9 y:17) color:red    effect:revert target:catcher)
			bonus(position:pos(x:5 y:11) color:green    effect:revert target:all)
			bonus(position:pos(x:16 y:7) color:red    effect:revert target:catcher)
			bonus(position:pos(x:16 y:3) color:red    effect:revert target:catcher)
			bonus(position:pos(x:16 y:17) color:red    effect:revert target:catcher)
			bonus(position:pos(x:10 y:10) color:white    effect:malware target:catcher)
			bonus(position:pos(x:8 y:16) color:white    effect:malware target:catcher)
			bonus(position:pos(x:17 y:5) color:white    effect:malware target:catcher)
			bonus(position:pos(x:6 y:15) color:white    effect:malware target:catcher)
		  ]
	   bombs: [bomb(position:pos(x:15 y:12) explodesIn:3) bomb(position:pos(x:9 y:8) explodesIn:6)]
	  )
 end
