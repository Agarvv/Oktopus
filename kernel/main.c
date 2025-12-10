#define VIDEO_MEMORY 0xB8000


int _start() {
     unsigned short *video_memory = (unsigned short *)VIDEO_MEMORY;
     *video_memory = 0x611F; 

    while(1) {} 
}

