
_test_2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	81 ec 00 04 00 00    	sub    $0x400,%esp
   struct pstat st;
   int pid = getpid();
  15:	e8 a3 02 00 00       	call   2bd <getpid>
  1a:	89 c3                	mov    %eax,%ebx
   int defaulttickets = 0;
   
   if(getpinfo(&st) == 0)
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  25:	50                   	push   %eax
  26:	e8 ba 02 00 00       	call   2e5 <getpinfo>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	85 c0                	test   %eax,%eax
  30:	75 28                	jne    5a <main+0x5a>
   {
    for(int i = 0; i < NPROC; i++) {
  32:	89 c2                	mov    %eax,%edx
  34:	eb 03                	jmp    39 <main+0x39>
  36:	83 c2 01             	add    $0x1,%edx
  39:	83 fa 3f             	cmp    $0x3f,%edx
  3c:	7f 30                	jg     6e <main+0x6e>
      if (st.inuse[i]) {
  3e:	83 bc 95 f8 fb ff ff 	cmpl   $0x0,-0x408(%ebp,%edx,4)
  45:	00 
  46:	74 ee                	je     36 <main+0x36>
        if(st.pid[i] == pid) {
  48:	39 9c 95 f8 fd ff ff 	cmp    %ebx,-0x208(%ebp,%edx,4)
  4f:	75 e5                	jne    36 <main+0x36>
          defaulttickets = st.tickets[i];
  51:	8b 84 95 f8 fc ff ff 	mov    -0x308(%ebp,%edx,4),%eax
  58:	eb dc                	jmp    36 <main+0x36>
      }
   }
   }
  else
  {
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 50 06 00 00       	push   $0x650
  62:	6a 01                	push   $0x1
  64:	e8 39 03 00 00       	call   3a2 <printf>
   exit();
  69:	e8 cf 01 00 00       	call   23d <exit>
  }

  
  if(defaulttickets == 1)
  6e:	83 f8 01             	cmp    $0x1,%eax
  71:	74 17                	je     8a <main+0x8a>
  {
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  }
  else
  {
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  73:	83 ec 08             	sub    $0x8,%esp
  76:	68 50 06 00 00       	push   $0x650
  7b:	6a 01                	push   $0x1
  7d:	e8 20 03 00 00       	call   3a2 <printf>
  82:	83 c4 10             	add    $0x10,%esp
  }
   exit();
  85:	e8 b3 01 00 00       	call   23d <exit>
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 67 06 00 00       	push   $0x667
  92:	6a 01                	push   $0x1
  94:	e8 09 03 00 00       	call   3a2 <printf>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	eb e7                	jmp    85 <main+0x85>

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	56                   	push   %esi
  a2:	53                   	push   %ebx
  a3:	8b 75 08             	mov    0x8(%ebp),%esi
  a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a9:	89 f0                	mov    %esi,%eax
  ab:	89 d1                	mov    %edx,%ecx
  ad:	83 c2 01             	add    $0x1,%edx
  b0:	89 c3                	mov    %eax,%ebx
  b2:	83 c0 01             	add    $0x1,%eax
  b5:	0f b6 09             	movzbl (%ecx),%ecx
  b8:	88 0b                	mov    %cl,(%ebx)
  ba:	84 c9                	test   %cl,%cl
  bc:	75 ed                	jne    ab <strcpy+0xd>
    ;
  return os;
}
  be:	89 f0                	mov    %esi,%eax
  c0:	5b                   	pop    %ebx
  c1:	5e                   	pop    %esi
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  cd:	eb 06                	jmp    d5 <strcmp+0x11>
    p++, q++;
  cf:	83 c1 01             	add    $0x1,%ecx
  d2:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  d5:	0f b6 01             	movzbl (%ecx),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 04                	je     e0 <strcmp+0x1c>
  dc:	3a 02                	cmp    (%edx),%al
  de:	74 ef                	je     cf <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  e0:	0f b6 c0             	movzbl %al,%eax
  e3:	0f b6 12             	movzbl (%edx),%edx
  e6:	29 d0                	sub    %edx,%eax
}
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strlen>:

uint
strlen(const char *s)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f0:	b8 00 00 00 00       	mov    $0x0,%eax
  f5:	eb 03                	jmp    fa <strlen+0x10>
  f7:	83 c0 01             	add    $0x1,%eax
  fa:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  fe:	75 f7                	jne    f7 <strlen+0xd>
    ;
  return n;
}
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <memset>:

void*
memset(void *dst, int c, uint n)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	57                   	push   %edi
 106:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 109:	89 d7                	mov    %edx,%edi
 10b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	fc                   	cld    
 112:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 114:	89 d0                	mov    %edx,%eax
 116:	8b 7d fc             	mov    -0x4(%ebp),%edi
 119:	c9                   	leave  
 11a:	c3                   	ret    

0000011b <strchr>:

char*
strchr(const char *s, char c)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 125:	eb 03                	jmp    12a <strchr+0xf>
 127:	83 c0 01             	add    $0x1,%eax
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	74 06                	je     137 <strchr+0x1c>
    if(*s == c)
 131:	38 ca                	cmp    %cl,%dl
 133:	75 f2                	jne    127 <strchr+0xc>
 135:	eb 05                	jmp    13c <strchr+0x21>
      return (char*)s;
  return 0;
 137:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    

0000013e <gets>:

char*
gets(char *buf, int max)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	57                   	push   %edi
 142:	56                   	push   %esi
 143:	53                   	push   %ebx
 144:	83 ec 1c             	sub    $0x1c,%esp
 147:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	bb 00 00 00 00       	mov    $0x0,%ebx
 14f:	89 de                	mov    %ebx,%esi
 151:	83 c3 01             	add    $0x1,%ebx
 154:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 157:	7d 2e                	jge    187 <gets+0x49>
    cc = read(0, &c, 1);
 159:	83 ec 04             	sub    $0x4,%esp
 15c:	6a 01                	push   $0x1
 15e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 161:	50                   	push   %eax
 162:	6a 00                	push   $0x0
 164:	e8 ec 00 00 00       	call   255 <read>
    if(cc < 1)
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	7e 17                	jle    187 <gets+0x49>
      break;
    buf[i++] = c;
 170:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 174:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 177:	3c 0a                	cmp    $0xa,%al
 179:	0f 94 c2             	sete   %dl
 17c:	3c 0d                	cmp    $0xd,%al
 17e:	0f 94 c0             	sete   %al
 181:	08 c2                	or     %al,%dl
 183:	74 ca                	je     14f <gets+0x11>
    buf[i++] = c;
 185:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 187:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 18b:	89 f8                	mov    %edi,%eax
 18d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5f                   	pop    %edi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    

00000195 <stat>:

int
stat(const char *n, struct stat *st)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	83 ec 08             	sub    $0x8,%esp
 19d:	6a 00                	push   $0x0
 19f:	ff 75 08             	push   0x8(%ebp)
 1a2:	e8 d6 00 00 00       	call   27d <open>
  if(fd < 0)
 1a7:	83 c4 10             	add    $0x10,%esp
 1aa:	85 c0                	test   %eax,%eax
 1ac:	78 24                	js     1d2 <stat+0x3d>
 1ae:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	ff 75 0c             	push   0xc(%ebp)
 1b6:	50                   	push   %eax
 1b7:	e8 d9 00 00 00       	call   295 <fstat>
 1bc:	89 c6                	mov    %eax,%esi
  close(fd);
 1be:	89 1c 24             	mov    %ebx,(%esp)
 1c1:	e8 9f 00 00 00       	call   265 <close>
  return r;
 1c6:	83 c4 10             	add    $0x10,%esp
}
 1c9:	89 f0                	mov    %esi,%eax
 1cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ce:	5b                   	pop    %ebx
 1cf:	5e                   	pop    %esi
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    
    return -1;
 1d2:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d7:	eb f0                	jmp    1c9 <stat+0x34>

000001d9 <atoi>:

int
atoi(const char *s)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	53                   	push   %ebx
 1dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1e0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1e5:	eb 10                	jmp    1f7 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1e7:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1ea:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1ed:	83 c1 01             	add    $0x1,%ecx
 1f0:	0f be c0             	movsbl %al,%eax
 1f3:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1f7:	0f b6 01             	movzbl (%ecx),%eax
 1fa:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1fd:	80 fb 09             	cmp    $0x9,%bl
 200:	76 e5                	jbe    1e7 <atoi+0xe>
  return n;
}
 202:	89 d0                	mov    %edx,%eax
 204:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	56                   	push   %esi
 20d:	53                   	push   %ebx
 20e:	8b 75 08             	mov    0x8(%ebp),%esi
 211:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 214:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 217:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 219:	eb 0d                	jmp    228 <memmove+0x1f>
    *dst++ = *src++;
 21b:	0f b6 01             	movzbl (%ecx),%eax
 21e:	88 02                	mov    %al,(%edx)
 220:	8d 49 01             	lea    0x1(%ecx),%ecx
 223:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 226:	89 d8                	mov    %ebx,%eax
 228:	8d 58 ff             	lea    -0x1(%eax),%ebx
 22b:	85 c0                	test   %eax,%eax
 22d:	7f ec                	jg     21b <memmove+0x12>
  return vdst;
}
 22f:	89 f0                	mov    %esi,%eax
 231:	5b                   	pop    %ebx
 232:	5e                   	pop    %esi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    

00000235 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 235:	b8 01 00 00 00       	mov    $0x1,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <exit>:
SYSCALL(exit)
 23d:	b8 02 00 00 00       	mov    $0x2,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <wait>:
SYSCALL(wait)
 245:	b8 03 00 00 00       	mov    $0x3,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <pipe>:
SYSCALL(pipe)
 24d:	b8 04 00 00 00       	mov    $0x4,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <read>:
SYSCALL(read)
 255:	b8 05 00 00 00       	mov    $0x5,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <write>:
SYSCALL(write)
 25d:	b8 10 00 00 00       	mov    $0x10,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <close>:
SYSCALL(close)
 265:	b8 15 00 00 00       	mov    $0x15,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <kill>:
SYSCALL(kill)
 26d:	b8 06 00 00 00       	mov    $0x6,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <exec>:
SYSCALL(exec)
 275:	b8 07 00 00 00       	mov    $0x7,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <open>:
SYSCALL(open)
 27d:	b8 0f 00 00 00       	mov    $0xf,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <mknod>:
SYSCALL(mknod)
 285:	b8 11 00 00 00       	mov    $0x11,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <unlink>:
SYSCALL(unlink)
 28d:	b8 12 00 00 00       	mov    $0x12,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <fstat>:
SYSCALL(fstat)
 295:	b8 08 00 00 00       	mov    $0x8,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <link>:
SYSCALL(link)
 29d:	b8 13 00 00 00       	mov    $0x13,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <mkdir>:
SYSCALL(mkdir)
 2a5:	b8 14 00 00 00       	mov    $0x14,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <chdir>:
SYSCALL(chdir)
 2ad:	b8 09 00 00 00       	mov    $0x9,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <dup>:
SYSCALL(dup)
 2b5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <getpid>:
SYSCALL(getpid)
 2bd:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <sbrk>:
SYSCALL(sbrk)
 2c5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <sleep>:
SYSCALL(sleep)
 2cd:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <uptime>:
SYSCALL(uptime)
 2d5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <settickets>:
SYSCALL(settickets)
 2dd:	b8 16 00 00 00       	mov    $0x16,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <getpinfo>:
SYSCALL(getpinfo)
 2e5:	b8 17 00 00 00       	mov    $0x17,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <mprotect>:
SYSCALL(mprotect)
 2ed:	b8 18 00 00 00       	mov    $0x18,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <munprotect>:
SYSCALL(munprotect)
 2f5:	b8 19 00 00 00       	mov    $0x19,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	83 ec 1c             	sub    $0x1c,%esp
 303:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 306:	6a 01                	push   $0x1
 308:	8d 55 f4             	lea    -0xc(%ebp),%edx
 30b:	52                   	push   %edx
 30c:	50                   	push   %eax
 30d:	e8 4b ff ff ff       	call   25d <write>
}
 312:	83 c4 10             	add    $0x10,%esp
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	57                   	push   %edi
 31b:	56                   	push   %esi
 31c:	53                   	push   %ebx
 31d:	83 ec 2c             	sub    $0x2c,%esp
 320:	89 45 d0             	mov    %eax,-0x30(%ebp)
 323:	89 d0                	mov    %edx,%eax
 325:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 327:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 32b:	0f 95 c1             	setne  %cl
 32e:	c1 ea 1f             	shr    $0x1f,%edx
 331:	84 d1                	test   %dl,%cl
 333:	74 44                	je     379 <printint+0x62>
    neg = 1;
    x = -xx;
 335:	f7 d8                	neg    %eax
 337:	89 c1                	mov    %eax,%ecx
    neg = 1;
 339:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 340:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 345:	89 c8                	mov    %ecx,%eax
 347:	ba 00 00 00 00       	mov    $0x0,%edx
 34c:	f7 f6                	div    %esi
 34e:	89 df                	mov    %ebx,%edi
 350:	83 c3 01             	add    $0x1,%ebx
 353:	0f b6 92 e0 06 00 00 	movzbl 0x6e0(%edx),%edx
 35a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 35e:	89 ca                	mov    %ecx,%edx
 360:	89 c1                	mov    %eax,%ecx
 362:	39 d6                	cmp    %edx,%esi
 364:	76 df                	jbe    345 <printint+0x2e>
  if(neg)
 366:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 36a:	74 31                	je     39d <printint+0x86>
    buf[i++] = '-';
 36c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 371:	8d 5f 02             	lea    0x2(%edi),%ebx
 374:	8b 75 d0             	mov    -0x30(%ebp),%esi
 377:	eb 17                	jmp    390 <printint+0x79>
    x = xx;
 379:	89 c1                	mov    %eax,%ecx
  neg = 0;
 37b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 382:	eb bc                	jmp    340 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 384:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 389:	89 f0                	mov    %esi,%eax
 38b:	e8 6d ff ff ff       	call   2fd <putc>
  while(--i >= 0)
 390:	83 eb 01             	sub    $0x1,%ebx
 393:	79 ef                	jns    384 <printint+0x6d>
}
 395:	83 c4 2c             	add    $0x2c,%esp
 398:	5b                   	pop    %ebx
 399:	5e                   	pop    %esi
 39a:	5f                   	pop    %edi
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
 39d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3a0:	eb ee                	jmp    390 <printint+0x79>

000003a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	57                   	push   %edi
 3a6:	56                   	push   %esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ab:	8d 45 10             	lea    0x10(%ebp),%eax
 3ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3b1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3b6:	bb 00 00 00 00       	mov    $0x0,%ebx
 3bb:	eb 14                	jmp    3d1 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3bd:	89 fa                	mov    %edi,%edx
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	e8 36 ff ff ff       	call   2fd <putc>
 3c7:	eb 05                	jmp    3ce <printf+0x2c>
      }
    } else if(state == '%'){
 3c9:	83 fe 25             	cmp    $0x25,%esi
 3cc:	74 25                	je     3f3 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3ce:	83 c3 01             	add    $0x1,%ebx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3d8:	84 c0                	test   %al,%al
 3da:	0f 84 20 01 00 00    	je     500 <printf+0x15e>
    c = fmt[i] & 0xff;
 3e0:	0f be f8             	movsbl %al,%edi
 3e3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3e6:	85 f6                	test   %esi,%esi
 3e8:	75 df                	jne    3c9 <printf+0x27>
      if(c == '%'){
 3ea:	83 f8 25             	cmp    $0x25,%eax
 3ed:	75 ce                	jne    3bd <printf+0x1b>
        state = '%';
 3ef:	89 c6                	mov    %eax,%esi
 3f1:	eb db                	jmp    3ce <printf+0x2c>
      if(c == 'd'){
 3f3:	83 f8 25             	cmp    $0x25,%eax
 3f6:	0f 84 cf 00 00 00    	je     4cb <printf+0x129>
 3fc:	0f 8c dd 00 00 00    	jl     4df <printf+0x13d>
 402:	83 f8 78             	cmp    $0x78,%eax
 405:	0f 8f d4 00 00 00    	jg     4df <printf+0x13d>
 40b:	83 f8 63             	cmp    $0x63,%eax
 40e:	0f 8c cb 00 00 00    	jl     4df <printf+0x13d>
 414:	83 e8 63             	sub    $0x63,%eax
 417:	83 f8 15             	cmp    $0x15,%eax
 41a:	0f 87 bf 00 00 00    	ja     4df <printf+0x13d>
 420:	ff 24 85 88 06 00 00 	jmp    *0x688(,%eax,4)
        printint(fd, *ap, 10, 1);
 427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42a:	8b 17                	mov    (%edi),%edx
 42c:	83 ec 0c             	sub    $0xc,%esp
 42f:	6a 01                	push   $0x1
 431:	b9 0a 00 00 00       	mov    $0xa,%ecx
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	e8 d9 fe ff ff       	call   317 <printint>
        ap++;
 43e:	83 c7 04             	add    $0x4,%edi
 441:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 444:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 447:	be 00 00 00 00       	mov    $0x0,%esi
 44c:	eb 80                	jmp    3ce <printf+0x2c>
        printint(fd, *ap, 16, 0);
 44e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 451:	8b 17                	mov    (%edi),%edx
 453:	83 ec 0c             	sub    $0xc,%esp
 456:	6a 00                	push   $0x0
 458:	b9 10 00 00 00       	mov    $0x10,%ecx
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	e8 b2 fe ff ff       	call   317 <printint>
        ap++;
 465:	83 c7 04             	add    $0x4,%edi
 468:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 46b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
 473:	e9 56 ff ff ff       	jmp    3ce <printf+0x2c>
        s = (char*)*ap;
 478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47b:	8b 30                	mov    (%eax),%esi
        ap++;
 47d:	83 c0 04             	add    $0x4,%eax
 480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 483:	85 f6                	test   %esi,%esi
 485:	75 15                	jne    49c <printf+0xfa>
          s = "(null)";
 487:	be 7f 06 00 00       	mov    $0x67f,%esi
 48c:	eb 0e                	jmp    49c <printf+0xfa>
          putc(fd, *s);
 48e:	0f be d2             	movsbl %dl,%edx
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	e8 64 fe ff ff       	call   2fd <putc>
          s++;
 499:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 49c:	0f b6 16             	movzbl (%esi),%edx
 49f:	84 d2                	test   %dl,%dl
 4a1:	75 eb                	jne    48e <printf+0xec>
      state = 0;
 4a3:	be 00 00 00 00       	mov    $0x0,%esi
 4a8:	e9 21 ff ff ff       	jmp    3ce <printf+0x2c>
        putc(fd, *ap);
 4ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b0:	0f be 17             	movsbl (%edi),%edx
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	e8 42 fe ff ff       	call   2fd <putc>
        ap++;
 4bb:	83 c7 04             	add    $0x4,%edi
 4be:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 03 ff ff ff       	jmp    3ce <printf+0x2c>
        putc(fd, c);
 4cb:	89 fa                	mov    %edi,%edx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	e8 28 fe ff ff       	call   2fd <putc>
      state = 0;
 4d5:	be 00 00 00 00       	mov    $0x0,%esi
 4da:	e9 ef fe ff ff       	jmp    3ce <printf+0x2c>
        putc(fd, '%');
 4df:	ba 25 00 00 00       	mov    $0x25,%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	e8 11 fe ff ff       	call   2fd <putc>
        putc(fd, c);
 4ec:	89 fa                	mov    %edi,%edx
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	e8 07 fe ff ff       	call   2fd <putc>
      state = 0;
 4f6:	be 00 00 00 00       	mov    $0x0,%esi
 4fb:	e9 ce fe ff ff       	jmp    3ce <printf+0x2c>
    }
  }
}
 500:	8d 65 f4             	lea    -0xc(%ebp),%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    

00000508 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 508:	55                   	push   %ebp
 509:	89 e5                	mov    %esp,%ebp
 50b:	57                   	push   %edi
 50c:	56                   	push   %esi
 50d:	53                   	push   %ebx
 50e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 511:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 514:	a1 84 09 00 00       	mov    0x984,%eax
 519:	eb 02                	jmp    51d <free+0x15>
 51b:	89 d0                	mov    %edx,%eax
 51d:	39 c8                	cmp    %ecx,%eax
 51f:	73 04                	jae    525 <free+0x1d>
 521:	39 08                	cmp    %ecx,(%eax)
 523:	77 12                	ja     537 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 525:	8b 10                	mov    (%eax),%edx
 527:	39 c2                	cmp    %eax,%edx
 529:	77 f0                	ja     51b <free+0x13>
 52b:	39 c8                	cmp    %ecx,%eax
 52d:	72 08                	jb     537 <free+0x2f>
 52f:	39 ca                	cmp    %ecx,%edx
 531:	77 04                	ja     537 <free+0x2f>
 533:	89 d0                	mov    %edx,%eax
 535:	eb e6                	jmp    51d <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 537:	8b 73 fc             	mov    -0x4(%ebx),%esi
 53a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 53d:	8b 10                	mov    (%eax),%edx
 53f:	39 d7                	cmp    %edx,%edi
 541:	74 19                	je     55c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 543:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 546:	8b 50 04             	mov    0x4(%eax),%edx
 549:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 54c:	39 ce                	cmp    %ecx,%esi
 54e:	74 1b                	je     56b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 550:	89 08                	mov    %ecx,(%eax)
  freep = p;
 552:	a3 84 09 00 00       	mov    %eax,0x984
}
 557:	5b                   	pop    %ebx
 558:	5e                   	pop    %esi
 559:	5f                   	pop    %edi
 55a:	5d                   	pop    %ebp
 55b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 55c:	03 72 04             	add    0x4(%edx),%esi
 55f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 562:	8b 10                	mov    (%eax),%edx
 564:	8b 12                	mov    (%edx),%edx
 566:	89 53 f8             	mov    %edx,-0x8(%ebx)
 569:	eb db                	jmp    546 <free+0x3e>
    p->s.size += bp->s.size;
 56b:	03 53 fc             	add    -0x4(%ebx),%edx
 56e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 571:	8b 53 f8             	mov    -0x8(%ebx),%edx
 574:	89 10                	mov    %edx,(%eax)
 576:	eb da                	jmp    552 <free+0x4a>

00000578 <morecore>:

static Header*
morecore(uint nu)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	53                   	push   %ebx
 57c:	83 ec 04             	sub    $0x4,%esp
 57f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 581:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 586:	77 05                	ja     58d <morecore+0x15>
    nu = 4096;
 588:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 58d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 594:	83 ec 0c             	sub    $0xc,%esp
 597:	50                   	push   %eax
 598:	e8 28 fd ff ff       	call   2c5 <sbrk>
  if(p == (char*)-1)
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	83 f8 ff             	cmp    $0xffffffff,%eax
 5a3:	74 1c                	je     5c1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5a5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5a8:	83 c0 08             	add    $0x8,%eax
 5ab:	83 ec 0c             	sub    $0xc,%esp
 5ae:	50                   	push   %eax
 5af:	e8 54 ff ff ff       	call   508 <free>
  return freep;
 5b4:	a1 84 09 00 00       	mov    0x984,%eax
 5b9:	83 c4 10             	add    $0x10,%esp
}
 5bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5bf:	c9                   	leave  
 5c0:	c3                   	ret    
    return 0;
 5c1:	b8 00 00 00 00       	mov    $0x0,%eax
 5c6:	eb f4                	jmp    5bc <morecore+0x44>

000005c8 <malloc>:

void*
malloc(uint nbytes)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	53                   	push   %ebx
 5cc:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	8d 58 07             	lea    0x7(%eax),%ebx
 5d5:	c1 eb 03             	shr    $0x3,%ebx
 5d8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5db:	8b 0d 84 09 00 00    	mov    0x984,%ecx
 5e1:	85 c9                	test   %ecx,%ecx
 5e3:	74 04                	je     5e9 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e5:	8b 01                	mov    (%ecx),%eax
 5e7:	eb 4a                	jmp    633 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5e9:	c7 05 84 09 00 00 88 	movl   $0x988,0x984
 5f0:	09 00 00 
 5f3:	c7 05 88 09 00 00 88 	movl   $0x988,0x988
 5fa:	09 00 00 
    base.s.size = 0;
 5fd:	c7 05 8c 09 00 00 00 	movl   $0x0,0x98c
 604:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 607:	b9 88 09 00 00       	mov    $0x988,%ecx
 60c:	eb d7                	jmp    5e5 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 60e:	74 19                	je     629 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 610:	29 da                	sub    %ebx,%edx
 612:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 615:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 618:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 61b:	89 0d 84 09 00 00    	mov    %ecx,0x984
      return (void*)(p + 1);
 621:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 627:	c9                   	leave  
 628:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 629:	8b 10                	mov    (%eax),%edx
 62b:	89 11                	mov    %edx,(%ecx)
 62d:	eb ec                	jmp    61b <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62f:	89 c1                	mov    %eax,%ecx
 631:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 633:	8b 50 04             	mov    0x4(%eax),%edx
 636:	39 da                	cmp    %ebx,%edx
 638:	73 d4                	jae    60e <malloc+0x46>
    if(p == freep)
 63a:	39 05 84 09 00 00    	cmp    %eax,0x984
 640:	75 ed                	jne    62f <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 642:	89 d8                	mov    %ebx,%eax
 644:	e8 2f ff ff ff       	call   578 <morecore>
 649:	85 c0                	test   %eax,%eax
 64b:	75 e2                	jne    62f <malloc+0x67>
 64d:	eb d5                	jmp    624 <malloc+0x5c>
