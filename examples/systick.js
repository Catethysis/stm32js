const SysTick = require('../peripheral/systick.js');

var sysTick = new SysTick(500);

sysTick.on('tick', function() {
	print('tick');
});