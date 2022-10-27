
_test_11:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
   int ppid = getpid();
  16:	e8 7b 02 00 00       	call   296 <getpid>
  1b:	89 c6                	mov    %eax,%esi

   if (fork() == 0) {     
  1d:	e8 ec 01 00 00       	call   20e <fork>
  22:	85 c0                	test   %eax,%eax
  24:	75 38                	jne    5e <main+0x5e>

      int *p = (int *)atoi(argv[1]);
  26:	83 ec 0c             	sub    $0xc,%esp
  29:	ff 73 04             	push   0x4(%ebx)
  2c:	e8 81 01 00 00       	call   1b2 <atoi>
      printf(1, "%d\n", *p);
  31:	83 c4 0c             	add    $0xc,%esp
  34:	ff 30                	push   (%eax)
  36:	68 28 06 00 00       	push   $0x628
  3b:	6a 01                	push   $0x1
  3d:	e8 39 03 00 00       	call   37b <printf>

      printf(1, "XV6_VM\t FAILED\n");
  42:	83 c4 08             	add    $0x8,%esp
  45:	68 2c 06 00 00       	push   $0x62c
  4a:	6a 01                	push   $0x1
  4c:	e8 2a 03 00 00       	call   37b <printf>
      
      kill(ppid);
  51:	89 34 24             	mov    %esi,(%esp)
  54:	e8 ed 01 00 00       	call   246 <kill>
      
      exit();
  59:	e8 b8 01 00 00       	call   216 <exit>
   } else {
      wait();
  5e:	e8 bb 01 00 00       	call   21e <wait>
   }

   printf(1, "XV6_VM\t SUCCESS\n");
  63:	83 ec 08             	sub    $0x8,%esp
  66:	68 3c 06 00 00       	push   $0x63c
  6b:	6a 01                	push   $0x1
  6d:	e8 09 03 00 00       	call   37b <printf>
   exit();
  72:	e8 9f 01 00 00       	call   216 <exit>

00000077 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	56                   	push   %esi
  7b:	53                   	push   %ebx
  7c:	8b 75 08             	mov    0x8(%ebp),%esi
  7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	89 f0                	mov    %esi,%eax
  84:	89 d1                	mov    %edx,%ecx
  86:	83 c2 01             	add    $0x1,%edx
  89:	89 c3                	mov    %eax,%ebx
  8b:	83 c0 01             	add    $0x1,%eax
  8e:	0f b6 09             	movzbl (%ecx),%ecx
  91:	88 0b                	mov    %cl,(%ebx)
  93:	84 c9                	test   %cl,%cl
  95:	75 ed                	jne    84 <strcpy+0xd>
    ;
  return os;
}
  97:	89 f0                	mov    %esi,%eax
  99:	5b                   	pop    %ebx
  9a:	5e                   	pop    %esi
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    

0000009d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  a6:	eb 06                	jmp    ae <strcmp+0x11>
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 04                	je     b9 <strcmp+0x1c>
  b5:	3a 02                	cmp    (%edx),%al
  b7:	74 ef                	je     a8 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  b9:	0f b6 c0             	movzbl %al,%eax
  bc:	0f b6 12             	movzbl (%edx),%edx
  bf:	29 d0                	sub    %edx,%eax
}
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    

000000c3 <strlen>:

uint
strlen(const char *s)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c9:	b8 00 00 00 00       	mov    $0x0,%eax
  ce:	eb 03                	jmp    d3 <strlen+0x10>
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  d7:	75 f7                	jne    d0 <strlen+0xd>
    ;
  return n;
}
  d9:	5d                   	pop    %ebp
  da:	c3                   	ret    

000000db <memset>:

void*
memset(void *dst, int c, uint n)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e2:	89 d7                	mov    %edx,%edi
  e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	fc                   	cld    
  eb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ed:	89 d0                	mov    %edx,%eax
  ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  fe:	eb 03                	jmp    103 <strchr+0xf>
 100:	83 c0 01             	add    $0x1,%eax
 103:	0f b6 10             	movzbl (%eax),%edx
 106:	84 d2                	test   %dl,%dl
 108:	74 06                	je     110 <strchr+0x1c>
    if(*s == c)
 10a:	38 ca                	cmp    %cl,%dl
 10c:	75 f2                	jne    100 <strchr+0xc>
 10e:	eb 05                	jmp    115 <strchr+0x21>
      return (char*)s;
  return 0;
 110:	b8 00 00 00 00       	mov    $0x0,%eax
}
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    

00000117 <gets>:

char*
gets(char *buf, int max)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	56                   	push   %esi
 11c:	53                   	push   %ebx
 11d:	83 ec 1c             	sub    $0x1c,%esp
 120:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 123:	bb 00 00 00 00       	mov    $0x0,%ebx
 128:	89 de                	mov    %ebx,%esi
 12a:	83 c3 01             	add    $0x1,%ebx
 12d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 130:	7d 2e                	jge    160 <gets+0x49>
    cc = read(0, &c, 1);
 132:	83 ec 04             	sub    $0x4,%esp
 135:	6a 01                	push   $0x1
 137:	8d 45 e7             	lea    -0x19(%ebp),%eax
 13a:	50                   	push   %eax
 13b:	6a 00                	push   $0x0
 13d:	e8 ec 00 00 00       	call   22e <read>
    if(cc < 1)
 142:	83 c4 10             	add    $0x10,%esp
 145:	85 c0                	test   %eax,%eax
 147:	7e 17                	jle    160 <gets+0x49>
      break;
    buf[i++] = c;
 149:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 150:	3c 0a                	cmp    $0xa,%al
 152:	0f 94 c2             	sete   %dl
 155:	3c 0d                	cmp    $0xd,%al
 157:	0f 94 c0             	sete   %al
 15a:	08 c2                	or     %al,%dl
 15c:	74 ca                	je     128 <gets+0x11>
    buf[i++] = c;
 15e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 160:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 164:	89 f8                	mov    %edi,%eax
 166:	8d 65 f4             	lea    -0xc(%ebp),%esp
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret    

0000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	push   0x8(%ebp)
 17b:	e8 d6 00 00 00       	call   256 <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x3d>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	push   0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 d9 00 00 00       	call   26e <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 9f 00 00 00       	call   23e <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x34>

000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b9:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1be:	eb 10                	jmp    1d0 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1c0:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1c3:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c6:	83 c1 01             	add    $0x1,%ecx
 1c9:	0f be c0             	movsbl %al,%eax
 1cc:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1d0:	0f b6 01             	movzbl (%ecx),%eax
 1d3:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d6:	80 fb 09             	cmp    $0x9,%bl
 1d9:	76 e5                	jbe    1c0 <atoi+0xe>
  return n;
}
 1db:	89 d0                	mov    %edx,%eax
 1dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	56                   	push   %esi
 1e6:	53                   	push   %ebx
 1e7:	8b 75 08             	mov    0x8(%ebp),%esi
 1ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1ed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f0:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1f2:	eb 0d                	jmp    201 <memmove+0x1f>
    *dst++ = *src++;
 1f4:	0f b6 01             	movzbl (%ecx),%eax
 1f7:	88 02                	mov    %al,(%edx)
 1f9:	8d 49 01             	lea    0x1(%ecx),%ecx
 1fc:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1ff:	89 d8                	mov    %ebx,%eax
 201:	8d 58 ff             	lea    -0x1(%eax),%ebx
 204:	85 c0                	test   %eax,%eax
 206:	7f ec                	jg     1f4 <memmove+0x12>
  return vdst;
}
 208:	89 f0                	mov    %esi,%eax
 20a:	5b                   	pop    %ebx
 20b:	5e                   	pop    %esi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20e:	b8 01 00 00 00       	mov    $0x1,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <exit>:
SYSCALL(exit)
 216:	b8 02 00 00 00       	mov    $0x2,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <wait>:
SYSCALL(wait)
 21e:	b8 03 00 00 00       	mov    $0x3,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <pipe>:
SYSCALL(pipe)
 226:	b8 04 00 00 00       	mov    $0x4,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <read>:
SYSCALL(read)
 22e:	b8 05 00 00 00       	mov    $0x5,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <write>:
SYSCALL(write)
 236:	b8 10 00 00 00       	mov    $0x10,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <close>:
SYSCALL(close)
 23e:	b8 15 00 00 00       	mov    $0x15,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <kill>:
SYSCALL(kill)
 246:	b8 06 00 00 00       	mov    $0x6,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <exec>:
SYSCALL(exec)
 24e:	b8 07 00 00 00       	mov    $0x7,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <open>:
SYSCALL(open)
 256:	b8 0f 00 00 00       	mov    $0xf,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <mknod>:
SYSCALL(mknod)
 25e:	b8 11 00 00 00       	mov    $0x11,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <unlink>:
SYSCALL(unlink)
 266:	b8 12 00 00 00       	mov    $0x12,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <fstat>:
SYSCALL(fstat)
 26e:	b8 08 00 00 00       	mov    $0x8,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <link>:
SYSCALL(link)
 276:	b8 13 00 00 00       	mov    $0x13,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <mkdir>:
SYSCALL(mkdir)
 27e:	b8 14 00 00 00       	mov    $0x14,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <chdir>:
SYSCALL(chdir)
 286:	b8 09 00 00 00       	mov    $0x9,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <dup>:
SYSCALL(dup)
 28e:	b8 0a 00 00 00       	mov    $0xa,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <getpid>:
SYSCALL(getpid)
 296:	b8 0b 00 00 00       	mov    $0xb,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <sbrk>:
SYSCALL(sbrk)
 29e:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <sleep>:
SYSCALL(sleep)
 2a6:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <uptime>:
SYSCALL(uptime)
 2ae:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <settickets>:
SYSCALL(settickets)
 2b6:	b8 16 00 00 00       	mov    $0x16,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <getpinfo>:
SYSCALL(getpinfo)
 2be:	b8 17 00 00 00       	mov    $0x17,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <mprotect>:
SYSCALL(mprotect)
 2c6:	b8 18 00 00 00       	mov    $0x18,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <munprotect>:
SYSCALL(munprotect)
 2ce:	b8 19 00 00 00       	mov    $0x19,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2d6:	55                   	push   %ebp
 2d7:	89 e5                	mov    %esp,%ebp
 2d9:	83 ec 1c             	sub    $0x1c,%esp
 2dc:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2df:	6a 01                	push   $0x1
 2e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e4:	52                   	push   %edx
 2e5:	50                   	push   %eax
 2e6:	e8 4b ff ff ff       	call   236 <write>
}
 2eb:	83 c4 10             	add    $0x10,%esp
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
 2f6:	83 ec 2c             	sub    $0x2c,%esp
 2f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 304:	0f 95 c1             	setne  %cl
 307:	c1 ea 1f             	shr    $0x1f,%edx
 30a:	84 d1                	test   %dl,%cl
 30c:	74 44                	je     352 <printint+0x62>
    neg = 1;
    x = -xx;
 30e:	f7 d8                	neg    %eax
 310:	89 c1                	mov    %eax,%ecx
    neg = 1;
 312:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 319:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 31e:	89 c8                	mov    %ecx,%eax
 320:	ba 00 00 00 00       	mov    $0x0,%edx
 325:	f7 f6                	div    %esi
 327:	89 df                	mov    %ebx,%edi
 329:	83 c3 01             	add    $0x1,%ebx
 32c:	0f b6 92 ac 06 00 00 	movzbl 0x6ac(%edx),%edx
 333:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 337:	89 ca                	mov    %ecx,%edx
 339:	89 c1                	mov    %eax,%ecx
 33b:	39 d6                	cmp    %edx,%esi
 33d:	76 df                	jbe    31e <printint+0x2e>
  if(neg)
 33f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 343:	74 31                	je     376 <printint+0x86>
    buf[i++] = '-';
 345:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 34a:	8d 5f 02             	lea    0x2(%edi),%ebx
 34d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 350:	eb 17                	jmp    369 <printint+0x79>
    x = xx;
 352:	89 c1                	mov    %eax,%ecx
  neg = 0;
 354:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 35b:	eb bc                	jmp    319 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 35d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 362:	89 f0                	mov    %esi,%eax
 364:	e8 6d ff ff ff       	call   2d6 <putc>
  while(--i >= 0)
 369:	83 eb 01             	sub    $0x1,%ebx
 36c:	79 ef                	jns    35d <printint+0x6d>
}
 36e:	83 c4 2c             	add    $0x2c,%esp
 371:	5b                   	pop    %ebx
 372:	5e                   	pop    %esi
 373:	5f                   	pop    %edi
 374:	5d                   	pop    %ebp
 375:	c3                   	ret    
 376:	8b 75 d0             	mov    -0x30(%ebp),%esi
 379:	eb ee                	jmp    369 <printint+0x79>

0000037b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	57                   	push   %edi
 37f:	56                   	push   %esi
 380:	53                   	push   %ebx
 381:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 384:	8d 45 10             	lea    0x10(%ebp),%eax
 387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 38a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 38f:	bb 00 00 00 00       	mov    $0x0,%ebx
 394:	eb 14                	jmp    3aa <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 396:	89 fa                	mov    %edi,%edx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	e8 36 ff ff ff       	call   2d6 <putc>
 3a0:	eb 05                	jmp    3a7 <printf+0x2c>
      }
    } else if(state == '%'){
 3a2:	83 fe 25             	cmp    $0x25,%esi
 3a5:	74 25                	je     3cc <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3a7:	83 c3 01             	add    $0x1,%ebx
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	0f 84 20 01 00 00    	je     4d9 <printf+0x15e>
    c = fmt[i] & 0xff;
 3b9:	0f be f8             	movsbl %al,%edi
 3bc:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3bf:	85 f6                	test   %esi,%esi
 3c1:	75 df                	jne    3a2 <printf+0x27>
      if(c == '%'){
 3c3:	83 f8 25             	cmp    $0x25,%eax
 3c6:	75 ce                	jne    396 <printf+0x1b>
        state = '%';
 3c8:	89 c6                	mov    %eax,%esi
 3ca:	eb db                	jmp    3a7 <printf+0x2c>
      if(c == 'd'){
 3cc:	83 f8 25             	cmp    $0x25,%eax
 3cf:	0f 84 cf 00 00 00    	je     4a4 <printf+0x129>
 3d5:	0f 8c dd 00 00 00    	jl     4b8 <printf+0x13d>
 3db:	83 f8 78             	cmp    $0x78,%eax
 3de:	0f 8f d4 00 00 00    	jg     4b8 <printf+0x13d>
 3e4:	83 f8 63             	cmp    $0x63,%eax
 3e7:	0f 8c cb 00 00 00    	jl     4b8 <printf+0x13d>
 3ed:	83 e8 63             	sub    $0x63,%eax
 3f0:	83 f8 15             	cmp    $0x15,%eax
 3f3:	0f 87 bf 00 00 00    	ja     4b8 <printf+0x13d>
 3f9:	ff 24 85 54 06 00 00 	jmp    *0x654(,%eax,4)
        printint(fd, *ap, 10, 1);
 400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 403:	8b 17                	mov    (%edi),%edx
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 01                	push   $0x1
 40a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	e8 d9 fe ff ff       	call   2f0 <printint>
        ap++;
 417:	83 c7 04             	add    $0x4,%edi
 41a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 420:	be 00 00 00 00       	mov    $0x0,%esi
 425:	eb 80                	jmp    3a7 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42a:	8b 17                	mov    (%edi),%edx
 42c:	83 ec 0c             	sub    $0xc,%esp
 42f:	6a 00                	push   $0x0
 431:	b9 10 00 00 00       	mov    $0x10,%ecx
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	e8 b2 fe ff ff       	call   2f0 <printint>
        ap++;
 43e:	83 c7 04             	add    $0x4,%edi
 441:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 444:	83 c4 10             	add    $0x10,%esp
      state = 0;
 447:	be 00 00 00 00       	mov    $0x0,%esi
 44c:	e9 56 ff ff ff       	jmp    3a7 <printf+0x2c>
        s = (char*)*ap;
 451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 454:	8b 30                	mov    (%eax),%esi
        ap++;
 456:	83 c0 04             	add    $0x4,%eax
 459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45c:	85 f6                	test   %esi,%esi
 45e:	75 15                	jne    475 <printf+0xfa>
          s = "(null)";
 460:	be 4d 06 00 00       	mov    $0x64d,%esi
 465:	eb 0e                	jmp    475 <printf+0xfa>
          putc(fd, *s);
 467:	0f be d2             	movsbl %dl,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	e8 64 fe ff ff       	call   2d6 <putc>
          s++;
 472:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 475:	0f b6 16             	movzbl (%esi),%edx
 478:	84 d2                	test   %dl,%dl
 47a:	75 eb                	jne    467 <printf+0xec>
      state = 0;
 47c:	be 00 00 00 00       	mov    $0x0,%esi
 481:	e9 21 ff ff ff       	jmp    3a7 <printf+0x2c>
        putc(fd, *ap);
 486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 489:	0f be 17             	movsbl (%edi),%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 42 fe ff ff       	call   2d6 <putc>
        ap++;
 494:	83 c7 04             	add    $0x4,%edi
 497:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 49a:	be 00 00 00 00       	mov    $0x0,%esi
 49f:	e9 03 ff ff ff       	jmp    3a7 <printf+0x2c>
        putc(fd, c);
 4a4:	89 fa                	mov    %edi,%edx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	e8 28 fe ff ff       	call   2d6 <putc>
      state = 0;
 4ae:	be 00 00 00 00       	mov    $0x0,%esi
 4b3:	e9 ef fe ff ff       	jmp    3a7 <printf+0x2c>
        putc(fd, '%');
 4b8:	ba 25 00 00 00       	mov    $0x25,%edx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 11 fe ff ff       	call   2d6 <putc>
        putc(fd, c);
 4c5:	89 fa                	mov    %edi,%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 07 fe ff ff       	call   2d6 <putc>
      state = 0;
 4cf:	be 00 00 00 00       	mov    $0x0,%esi
 4d4:	e9 ce fe ff ff       	jmp    3a7 <printf+0x2c>
    }
  }
}
 4d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4dc:	5b                   	pop    %ebx
 4dd:	5e                   	pop    %esi
 4de:	5f                   	pop    %edi
 4df:	5d                   	pop    %ebp
 4e0:	c3                   	ret    

000004e1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	57                   	push   %edi
 4e5:	56                   	push   %esi
 4e6:	53                   	push   %ebx
 4e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ea:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ed:	a1 54 09 00 00       	mov    0x954,%eax
 4f2:	eb 02                	jmp    4f6 <free+0x15>
 4f4:	89 d0                	mov    %edx,%eax
 4f6:	39 c8                	cmp    %ecx,%eax
 4f8:	73 04                	jae    4fe <free+0x1d>
 4fa:	39 08                	cmp    %ecx,(%eax)
 4fc:	77 12                	ja     510 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4fe:	8b 10                	mov    (%eax),%edx
 500:	39 c2                	cmp    %eax,%edx
 502:	77 f0                	ja     4f4 <free+0x13>
 504:	39 c8                	cmp    %ecx,%eax
 506:	72 08                	jb     510 <free+0x2f>
 508:	39 ca                	cmp    %ecx,%edx
 50a:	77 04                	ja     510 <free+0x2f>
 50c:	89 d0                	mov    %edx,%eax
 50e:	eb e6                	jmp    4f6 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 510:	8b 73 fc             	mov    -0x4(%ebx),%esi
 513:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 516:	8b 10                	mov    (%eax),%edx
 518:	39 d7                	cmp    %edx,%edi
 51a:	74 19                	je     535 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 51c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 51f:	8b 50 04             	mov    0x4(%eax),%edx
 522:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 525:	39 ce                	cmp    %ecx,%esi
 527:	74 1b                	je     544 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 529:	89 08                	mov    %ecx,(%eax)
  freep = p;
 52b:	a3 54 09 00 00       	mov    %eax,0x954
}
 530:	5b                   	pop    %ebx
 531:	5e                   	pop    %esi
 532:	5f                   	pop    %edi
 533:	5d                   	pop    %ebp
 534:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 535:	03 72 04             	add    0x4(%edx),%esi
 538:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 53b:	8b 10                	mov    (%eax),%edx
 53d:	8b 12                	mov    (%edx),%edx
 53f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 542:	eb db                	jmp    51f <free+0x3e>
    p->s.size += bp->s.size;
 544:	03 53 fc             	add    -0x4(%ebx),%edx
 547:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 54a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 54d:	89 10                	mov    %edx,(%eax)
 54f:	eb da                	jmp    52b <free+0x4a>

00000551 <morecore>:

static Header*
morecore(uint nu)
{
 551:	55                   	push   %ebp
 552:	89 e5                	mov    %esp,%ebp
 554:	53                   	push   %ebx
 555:	83 ec 04             	sub    $0x4,%esp
 558:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 55a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 55f:	77 05                	ja     566 <morecore+0x15>
    nu = 4096;
 561:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 566:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 56d:	83 ec 0c             	sub    $0xc,%esp
 570:	50                   	push   %eax
 571:	e8 28 fd ff ff       	call   29e <sbrk>
  if(p == (char*)-1)
 576:	83 c4 10             	add    $0x10,%esp
 579:	83 f8 ff             	cmp    $0xffffffff,%eax
 57c:	74 1c                	je     59a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 57e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 581:	83 c0 08             	add    $0x8,%eax
 584:	83 ec 0c             	sub    $0xc,%esp
 587:	50                   	push   %eax
 588:	e8 54 ff ff ff       	call   4e1 <free>
  return freep;
 58d:	a1 54 09 00 00       	mov    0x954,%eax
 592:	83 c4 10             	add    $0x10,%esp
}
 595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 598:	c9                   	leave  
 599:	c3                   	ret    
    return 0;
 59a:	b8 00 00 00 00       	mov    $0x0,%eax
 59f:	eb f4                	jmp    595 <morecore+0x44>

000005a1 <malloc>:

void*
malloc(uint nbytes)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	53                   	push   %ebx
 5a5:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	8d 58 07             	lea    0x7(%eax),%ebx
 5ae:	c1 eb 03             	shr    $0x3,%ebx
 5b1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b4:	8b 0d 54 09 00 00    	mov    0x954,%ecx
 5ba:	85 c9                	test   %ecx,%ecx
 5bc:	74 04                	je     5c2 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5be:	8b 01                	mov    (%ecx),%eax
 5c0:	eb 4a                	jmp    60c <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5c2:	c7 05 54 09 00 00 58 	movl   $0x958,0x954
 5c9:	09 00 00 
 5cc:	c7 05 58 09 00 00 58 	movl   $0x958,0x958
 5d3:	09 00 00 
    base.s.size = 0;
 5d6:	c7 05 5c 09 00 00 00 	movl   $0x0,0x95c
 5dd:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5e0:	b9 58 09 00 00       	mov    $0x958,%ecx
 5e5:	eb d7                	jmp    5be <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5e7:	74 19                	je     602 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5e9:	29 da                	sub    %ebx,%edx
 5eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5ee:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5f1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f4:	89 0d 54 09 00 00    	mov    %ecx,0x954
      return (void*)(p + 1);
 5fa:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 600:	c9                   	leave  
 601:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 602:	8b 10                	mov    (%eax),%edx
 604:	89 11                	mov    %edx,(%ecx)
 606:	eb ec                	jmp    5f4 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 608:	89 c1                	mov    %eax,%ecx
 60a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 60c:	8b 50 04             	mov    0x4(%eax),%edx
 60f:	39 da                	cmp    %ebx,%edx
 611:	73 d4                	jae    5e7 <malloc+0x46>
    if(p == freep)
 613:	39 05 54 09 00 00    	cmp    %eax,0x954
 619:	75 ed                	jne    608 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 61b:	89 d8                	mov    %ebx,%eax
 61d:	e8 2f ff ff ff       	call   551 <morecore>
 622:	85 c0                	test   %eax,%eax
 624:	75 e2                	jne    608 <malloc+0x67>
 626:	eb d5                	jmp    5fd <malloc+0x5c>
