// cdl interface bindings for python 
%module cdl
%{
#include "cdl.h"
#include "Python.h"
#include "arrayobject.h"
%}

%init %{
	import_array();
%}

%include local_typemaps.i
%apply float *OUTPUT {float *x_out, float *y_out, float *a_out, float *b_out,
	float *c_out, float *d_out, float *tx_out, float *ty_out, 
	float *contrast_out,
	float *z1_out, float *z2_out}
%apply int *OUTPUT {int *zt_out, int *ztrans_out, int *frame_out,
	int *nsample_out, int *nlines_out, int *configno_out, int *w_out,
	int *h_out, int *nframes_out, int *nf_out, int *fb_out  }
%apply char *OUTPUT {char *name_out, char *title_out, char *imname_out,
	char *imtitle_out}
%apply char *OUTPUT_1CHAR {char *key_out_1char}


%typemap(python,in) char *STR_OR_NULL {
	int size;
	if (!PyString_Check($source)) {
		PyErr_SetString(PyExc_TypeError,"not a string");
		return NULL;
	}
	size = PyString_Size($source);
	if (size == 0) {
		$target = NULL;
	} else {
		$target = PyString_AsString($source);
	}
}
%apply char *STR_OR_NULL {char *imtdev}
%typemap(python,in) xuchar * {
	if (!PyString_Check($source)) {
		PyErr_SetString(PyExc_TypeError,"not a string");
		return NULL;
	}
	$target = (uchar *) PyString_AsString($source);	
}
%typemap(python,in) uchar *NUMARR_IN {
	if (!PyArray_Check($source)) {
		PyErr_SetString(PyExc_TypeError,"not a Numeric array");
		return NULL;
	}
	if (!PyArray_ISCONTIGUOUS((PyArrayObject *)$source)) {
		PyErr_SetString(PyExc_TypeError,
			"not a contiguous Numeric Array");
		return NULL;
	}
	$target = (uchar *) ((PyArrayObject *)$source)->data;
}

%typemap(python,in) uchar **NUMARR_INOUT {
	uchar *tempptr;
	if (!PyArray_Check($source)) {
		PyErr_SetString(PyExc_TypeError,"not a Numeric array");
		return NULL;
	}
	if (!PyArray_ISCONTIGUOUS((PyArrayObject *)$source)) {
		PyErr_SetString(PyExc_TypeError,
			"not a contiguous Numeric Array");
		return NULL;
	}
	tempptr = (uchar *) ((PyArrayObject *)$source)->data;
	$target = (uchar **) &tempptr;
}
%apply uchar *NUMARR_IN {uchar *pix_in}
%apply uchar **NUMARR_INOUT {uchar **pix_inout}
%inline %{

%}
#define SWIGSTUFF
%include "/data/eclipse2/perry/scdl/cdl.h"





