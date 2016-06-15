[![Build Status](https://travis-ci.org/Catethysis/stm32js.svg?branch=master)](https://travis-ci.org/Catethysis/stm32js)

# stm32js

`stm32js` is a framework which gives you a way to write scripts for STM32 in JavaScript.

## About it

`stm32js` provides a hardware abstraction layer (HAL) to common STM32F4 peripheral in a set of two-way C++ ↔ JS bindings.

In other words, now you can program your STM32F4Discovery using JS, and ready-to-use libraries is also available.

## What's underneath

`stm32js` is lying in between web technologies and embedded development, and trying to get the best from two worlds.

It consists of several parts:

1. [Duktape](https://github.com/svaarala/duktape), the light-weight JS engine with small runtime/context memory footprint
2. [Babel](https://github.com/babel/babel), an ES6 → ES5 transpiler
3. [Browserify](https://github.com/substack/node-browserify), a RequireJS resolving tool
4. [Uglify](https://github.com/terinjokes/gulp-uglify) to produce compact JS code
5. [Gulp](https://github.com/gulpjs/gulp) to rule all the JS code processing
6. [GCC/Make](https://launchpad.net/gcc-arm-embedded) that builds the Core
7. [CMSIS](http://www.arm.com/products/processors/cortex-m/cortex-microcontroller-software-interface-standard.php) proudly provided by ARM and STM32, that gives all peripheral descriptions
8. Custom HAL libraries to access the STM32 hardware, such as init functions and common calls.

## Examples

`stm32js` is very easy to use for those who have an experience with JS, so I'll show you some particular framework use cases.

### SysTick

For example, let's ask the system timer to tick every 500 milliseconds. Didn't you forget about ES6 support? You can use arrow functions in here.
```javascript
const SysTick = require('../peripheral/systick');

var sysTick = new SysTick(500);

sysTick.on('tick', () => {
	print('tick');
});
```

`print()` function will output its argument to SWO so you can see it in "Terminal I/O" window in IAR or appropriate tool in other IDE or ST-Link Utility.