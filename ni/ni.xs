#ifdef __cplusplus
extern "C" {
#endif
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef __cplusplus
}
#endif

#ifdef UNIX
#include <ugpib.h>
#endif

#ifdef WIN32
#undef BIN          // Ugly bit to appease namespace polution in GPIB
#include <decl-32.h>
#endif


/*
    Extra implementations
    bd ibcnt
    bd iberr
    bd ibsta

    Not going to implement
    bd ibrda(...)
    bd ibwrta(...)
    b  ibcmda(ud, *buf, cnt)

    Not implemented
    bd ibfind(*name)
    bd ibnotify(ud, mask, callback, *refdata)

    There are all of the routines:
    bd ibask(ud, option *value)
    d  ibbna(ud, *bname)
    b  ibcac(ud, v)
    d  ibclr(ud)
    b  ibcmd(ud, *buf, cnt)
    b  ibcmda(ud, *buf, cnt)
    bd ibconfig(option, value)
    d  ibdev(...)
    b  ibdma(ud, v)
    bd ibeos(ud, v)
    bd ibeot(ud, v)
    bd ibfind(*name)
    b  ibgts(ud, v)
    b  ibist(ud, v)
    b  iblines(ud, *clines)
    bd ibln(ud, pad, sad, *listen)
    bd ibloc(ud)
    bd ibnotify(ud, mask, callback, *refdata)
    bd ibonl(ud, v)
    bd ibpad(ud, v)
    d  ibpct(ud)
    bd ibppc(ud, v)
    bd ibrd(...)
    bd ibrda(...)
    bd ibrdf(ud, *fname)
    bd ibrpp(ud, *ppr)
    b  ibrsc(ud, v)
    d  ibrsp(ud, *spr)
    b  ibrsv(ud, v)
    bd ibsad(ud, v)
    b  ibsic(ud)
    b  ibsre(ud, v)
    bd ibstop(ud)
    bd ibtmo(ud, v)
    d  ibtrg(ud)
    bd ibwait(ud, mask)
    bd ibwrt(...)
    bd ibwrta(...)
    bd ibwrtf(ud, *fname)
*/


typedef struct {
    int     fd;
    int     ibcnt;
    int     ibsta;
    int     iberr;
} GpibStruct;
typedef GpibStruct *GPIB_ni;

#ifdef UNIX
/* Stat isn't getting linked-in for some reason, so I'm 
   emulating it with fstat(), which is linked-in okay. */
int
stat(const char *fn, struct stat *buf)
{
    int     fd, rv;;

    // printf("Problem child stat() got called...emulating\n");
    fd = open(fn, O_RDONLY);
    if (fd < 0)
        return fd;
    rv = fstat(fd, buf);
    close (fd);
    return rv;
}
#endif

static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(char *name, int arg)
{
    errno = 0;
    switch (*name) {
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

MODULE = GPIB::ni		PACKAGE = GPIB::ni

double
constant(name,arg)
	char *		name
	int		arg

GPIB_ni
ibdev(board, pad, sad, tmo, eot, eos)
    int     board;
    int     pad;
    int     sad;
    int     tmo;
    int     eot;
    int     eos;

    PREINIT:
    GPIB_ni    g;

    CODE:
    g = (GPIB_ni) safemalloc(sizeof(GpibStruct));
    g->fd = ibdev(board, pad, sad, tmo, eot, eos);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = g;

    OUTPUT:
    RETVAL

GPIB_ni
ibfind(name)
    char    *name;

    PREINIT:
    GPIB_ni    g;

    CODE:
    g = (GPIB_ni) safemalloc(sizeof(GpibStruct));
    g->fd = ibfind(name);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = g;

    OUTPUT:
    RETVAL

void 
DESTROY(g)
    GPIB_ni    g

    CODE:
    free(g);

int
ibclr(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibclr(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibsic(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibsic(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibloc(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibloc(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibpct(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibpct(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibstop(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibstop(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibrsp(g)
    GPIB_ni    g

    PREINIT:
    char        spx;

    CODE:
    spx = 0;
    ibrsp(g->fd, &spx);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = spx;

    OUTPUT:
    RETVAL

int
ibrpp(g)
    GPIB_ni    g

    PREINIT:
    char        spx;

    CODE:
    spx = 0;
    ibrpp(g->fd, &spx);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = spx;

    OUTPUT:
    RETVAL

int 
ibask(g, option)
    GPIB_ni    g
    int     option

    PREINIT:
    int        value;

    CODE:
    value = 0;
    ibask(g->fd, option, &value);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = value;

    OUTPUT:
    RETVAL

int 
ibln(g, pad, sad)
    GPIB_ni    g
    int     pad
    int     sad

    PREINIT:
    short   listen;

    CODE:
    listen = 0;
    ibln(g->fd, pad, sad, &listen);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = listen;

    OUTPUT:
    RETVAL

int 
iblines(g)
    GPIB_ni    g

    PREINIT:
    short       value;

    CODE:
    value = 0;
    iblines(g->fd, &value);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    RETVAL = value;

    OUTPUT:
    RETVAL

int 
ibbna(g, name)
    GPIB_ni    g
    char    *name

    CODE:
    RETVAL = ibbna(g->fd, name);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibsre(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibsre(g->fd,v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int 
ibconfig(g, option, value)
    GPIB_ni    g
    int     option
    int     value

    CODE:
    RETVAL = ibconfig(g->fd, option, value);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibtmo(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibtmo(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibtrg(g)
    GPIB_ni    g

    CODE:
    RETVAL = ibtrg(g->fd);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL


SV *
ibrd(g, cnt)
    GPIB_ni    g
    int  cnt;

    PREINIT:
    char    *buf;
    char    sbuf[1024];
    int rc;
    SV      *sv;

    CODE:
    if (cnt <= 1024)
        buf = sbuf;
    else
        buf = (char *) safemalloc(cnt);
    sv = &PL_sv_undef;
    rc = ibrd(g->fd, buf, cnt);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;
    if((rc & ERR) == 0)
        sv = newSVpvn(buf, ibcnt);
    RETVAL = sv;
    // sv_setsv(ST(0), sv);

    if (cnt > 1024)
        safefree(buf);

    OUTPUT:
    RETVAL

int
ibwrt(g, buf)
    GPIB_ni    g
    char *buf

    PREINIT:
    unsigned long cnt;

    CODE:
    cnt = SvCUR(ST(1));
    RETVAL = ibwrt(g->fd, buf, cnt);

    OUTPUT:
    RETVAL

int
ibcmd(g, buf)
    GPIB_ni    g
    char *buf

    PREINIT:
    unsigned long cnt;

    CODE:
    cnt = SvCUR(ST(1));
    RETVAL = ibcmd(g->fd, buf, cnt);

    OUTPUT:
    RETVAL

int
ibcac(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibcac(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibrdf(g, fname)
    GPIB_ni    g
    char    *fname

    CODE:
    RETVAL = ibrdf(g->fd, fname);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibwrtf(g, fname)
    GPIB_ni    g
    char    *fname

    CODE:
    RETVAL = ibwrtf(g->fd, fname);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibdma(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibdma(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibeos(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibeos(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibeot(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibeot(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibgts(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibgts(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibist(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibist(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibonl(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibonl(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibpad(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibpad(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibppc(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibppc(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibrsc(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibrsc(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibrsv(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibrsv(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibsad(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibsad(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

int
ibwait(g, v)
    GPIB_ni    g
    int v

    CODE:
    RETVAL = ibwait(g->fd, v);
    g->ibcnt = ibcnt;
    g->ibsta = ibsta;
    g->iberr = iberr;

    OUTPUT:
    RETVAL

    
#    These three are just for accessing the elements
#    of the Gpib structure.
int
ibcnt(g)
    GPIB_ni    g

    CODE:
    RETVAL = g->ibcnt;

    OUTPUT:
    RETVAL

int
iberr(g)
    GPIB_ni    g

    CODE:
    RETVAL = g->iberr;

    OUTPUT:
    RETVAL

int
ibsta(g)
    GPIB_ni    g

    CODE:
    RETVAL = g->ibsta;

    OUTPUT:
    RETVAL
