// #include "./third_party/duktape/duktape.h"
   #include "../third-party/duktape/duktape.h"

void SystemInit() {}
void __errno(){}
void ADC_IRQHandler() {}

void delay()
{
	for(volatile int i = 0; i < 100000; i++);
}

duk_context *ctx;

duk_ret_t LED_Toggle(duk_context *ctx)
{
	//HAL_GPIO_TogglePin(GPIOD, GPIO_PIN_15);
	*(uint32_t *)0x40020C14  = 0x00000000;
	delay();
	*(uint32_t *)0x40020C14  = 0x00008000;
	delay();
	return 1;
}

int safeEval(duk_context* ctx)
{
	duk_eval(ctx);
	return 0;
}

int safeCall(duk_context* ctx)
{
	duk_call(ctx, 1 /* number of params */);
	return 1;
}

int main(int argc, char *argv[]) {
	/**(uint32_t *)0x40023830 |= 0x8;
	*(uint32_t *)0x40020C00 |= 0x55000000;
	*(uint32_t *)0x40020C14  = 0x00000000;
	while(1) {
		*(uint32_t *)0x40020C14  = 0x00000000;
		delay();
		*(uint32_t *)0x40020C14  = 0x00008000;
		delay();
	}
	duk_context *ctx = duk_create_heap_default();
	duk_eval_string(ctx, "'Hello world!'");
	duk_destroy_heap(ctx);
	*/

	*(uint32_t *)0x40023830 |= 0x8;
	*(uint32_t *)0x40020C00 |= 0x55000000;
	*(uint32_t *)0x40020C14  = 0x00000000;
	ctx = duk_create_heap_default();
	duk_push_global_object(ctx);
	duk_push_c_function(ctx, LED_Toggle, DUK_VARARGS);
    duk_put_prop_string(ctx, -2, "LED_Toggle");
	duk_push_string(ctx, "blink = function() { LED_Toggle(); };");
	duk_safe_call(ctx, safeEval, 1, 1);
	
	while (1)
	{
		duk_push_global_object(ctx);
		duk_get_prop_string(ctx, -1, "blink");
		duk_push_string(ctx, "0");
		duk_safe_call(ctx, safeCall, 1, 0);
		duk_pop_2(ctx);
		//for(volatile int i = 0; i < 100000; i++);
		//delay();
	}

	return 0;
}
