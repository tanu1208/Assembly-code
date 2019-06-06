#include <stdio.h>

extern long hms_to_sec (long h, long m, long s);
extern long sec_to_h (long sec);
extern long sec_to_m (long sec);
extern long sec_to_s (long sec);

long data[] = { 12, 65, 3600, 3750, 36002 };

int main (void) 
{
  int i, data_len = sizeof(data)/sizeof(data[0]);

  for (i = 0;  i < data_len;  i++) {
    long h = sec_to_h(data[i]);
    long m = sec_to_m(data[i]);
    long s = sec_to_s(data[i]);
    long res = hms_to_sec(h,m,s);

    printf("%5d ==> %02d:%02d:%02d ==> %5d\n", data[i], h, m, s, res);
  }
}