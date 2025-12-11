#define VIDEO_MEMORY 0xB8000
#define VIDEO_ROWS 25 
#define VIDEO_COLS 80

void printc(int col, int row, char c, char f) {
   // x = (rows * rows_size) + col 

    int offset = (row * VIDEO_ROWS) + col;
    unsigned short *addr = (unsigned short *)VIDEO_MEMORY + offset;
    c = (unsigned short)c; 
    f = (unsigned short)f; 

    *addr = (f << 8) | c; 

    return 0; 
}


int _start() {
     //unsigned short *video_memory = (unsigned short *)VIDEO_MEMORY;
    // *video_memory = 0x1F61;  // blue, 'a'
    printc(1, 1, 'A', 0x1F); 

    while(1) {} 
}

