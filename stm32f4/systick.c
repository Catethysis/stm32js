#include "duktape.h"

uint32_t systick_divider = 0;

duk_ret_t SysTick_init(duk_context *ctx)
{
	HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq() / 1000);
	HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);
	systick_divider = (uint32_t)duk_to_int32(ctx, 0);
	return 1;
}

void SysTick_IRQ_Handler(void)
{
	if(counter++ > systick_divider) {
		duk_push_global_object(ctx);
		duk_get_prop_string(ctx, -1, "SysTick_irq");
		duk_push_string(ctx, "0");
		duk_safe_call(ctx, safeCall, 1, 0);
		duk_pop_2(ctx);
		counter = 0;
	}
}

void register_C_bindings_systick()
{
	duk_push_global_object(ctx);
	duk_push_c_function(ctx, SysTick_init, DUK_VARARGS);
	duk_put_prop_string(ctx, -2, "__C_SysTick_init");
}