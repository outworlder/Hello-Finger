#include "fprint.h"
#include "string.h"		/* Memcpy */

int fp_do_verify(fp_dev* device, fp_print_data* enrolled_print, fp_img **image, fp_img *destination) {
  fp_verify-finger-img(device, enrolled_print, image);
  memcpy(destination, image, sizeof(image));
  /* Dados copiados para a área "managed". Liberando o buffer retornado pela libfprint */
  free(image);			/* Todo: pode-se usar "free" aqui? */
}
