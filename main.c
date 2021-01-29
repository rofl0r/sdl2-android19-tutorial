#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <assert.h>

#include "SDL.h"

unsigned const char bmp_data[] =
#include "sdl2-bmp.h"
;

const unsigned long bmp_data_size = sizeof(bmp_data);
const int bmp_data_w = 640;
const int bmp_data_h = 400;

static SDL_RWops* bmp_to_rwops(void) {
	SDL_RWops* ret = SDL_RWFromConstMem(bmp_data, bmp_data_size);
	return ret;
}

typedef struct Sprite
{
	SDL_Texture* texture;
	Uint16 w;
	Uint16 h;
} Sprite;

/* Adapted from SDL's testspriteminimal.c */
Sprite LoadSprite(const char* file, SDL_Renderer* renderer)
{
	Sprite result;
	result.texture = NULL;
	result.w = 0;
	result.h = 0;
	
    SDL_Surface* temp;

    /* Load the sprite image */
    temp = SDL_LoadBMP_RW(bmp_to_rwops(), 0);
         //SDL_LoadBMP(file);
    if (temp == NULL)
	{
        fprintf(stderr, "Couldn't load %s: %s\n", file, SDL_GetError());
        return result;
    }
    result.w = temp->w;
    result.h = temp->h;

	assert(result.w == bmp_data_w);

    /* Create texture from the image */
    result.texture = SDL_CreateTextureFromSurface(renderer, temp);
    if (!result.texture) {
        fprintf(stderr, "Couldn't create texture: %s\n", SDL_GetError());
        SDL_FreeSurface(temp);
        return result;
    }
    SDL_FreeSurface(temp);

    return result;
}

void draw(SDL_Window* window, SDL_Renderer* renderer, const Sprite sprite)
{
	int w, h;
	SDL_GetWindowSize(window, &w, &h);
	SDL_Rect destRect = {w/2 - sprite.w/2, h/2 - sprite.h/2, sprite.w, sprite.h};
	/* Blit the sprite onto the screen */
	SDL_RenderCopy(renderer, sprite.texture, NULL, &destRect);
}

int main(int argc, char *argv[])
{
    SDL_Window *window;
    SDL_Renderer *renderer;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        SDL_LogError(SDL_LOG_CATEGORY_APPLICATION, "Couldn't initialize SDL: %s", SDL_GetError());
        return 3;
    }

    if(SDL_CreateWindowAndRenderer(640, 480, SDL_WINDOW_FULLSCREEN_DESKTOP, &window, &renderer) < 0)
        exit(2);

	Sprite sprite = LoadSprite("image.bmp", renderer);
    if(sprite.texture == NULL)
        exit(2);

    /* Main render loop */
    Uint8 done = 0;
    SDL_Event event;
    while(!done)
	{
        /* Check for events */
        while(SDL_PollEvent(&event))
		{
            if(event.type == SDL_QUIT || event.type == SDL_KEYDOWN || event.type == SDL_FINGERDOWN)
			{
                done = 1;
            }
        }
		
		
		/* Draw a gray background */
		SDL_SetRenderDrawColor(renderer, 0xA0, 0xA0, 0xA0, 0xFF);
		SDL_RenderClear(renderer);
		
		draw(window, renderer, sprite);
	
		/* Update the screen! */
		SDL_RenderPresent(renderer);
		
		SDL_Delay(10);
    }

    exit(0);
}
