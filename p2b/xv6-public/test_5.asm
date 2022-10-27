
_test_5:     file format elf32-i386


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
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
  if(settickets(10) == -1)
  11:	6a 0a                	push   $0xa
  13:	e8 72 02 00 00       	call   28a <settickets>
  18:	83 c4 10             	add    $0x10,%esp
  1b:	83 f8 ff             	cmp    $0xffffffff,%eax
  1e:	74 17                	je     37 <main+0x37>
  {
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  }
  else
  {
   printf(1, "XV6_SCHEDULER\t FAILED\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 14 06 00 00       	push   $0x614
  28:	6a 01                	push   $0x1
  2a:	e8 20 03 00 00       	call   34f <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  }
   exit();
  32:	e8 b3 01 00 00       	call   1ea <exit>
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	68 fc 05 00 00       	push   $0x5fc
  3f:	6a 01                	push   $0x1
  41:	e8 09 03 00 00       	call   34f <printf>
  46:	83 c4 10             	add    $0x10,%esp
  49:	eb e7                	jmp    32 <main+0x32>

0000004b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4b:	55                   	push   %ebp
  4c:	89 e5                	mov    %esp,%ebp
  4e:	56                   	push   %esi
  4f:	53                   	push   %ebx
  50:	8b 75 08             	mov    0x8(%ebp),%esi
  53:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  56:	89 f0                	mov    %esi,%eax
  58:	89 d1                	mov    %edx,%ecx
  5a:	83 c2 01             	add    $0x1,%edx
  5d:	89 c3                	mov    %eax,%ebx
  5f:	83 c0 01             	add    $0x1,%eax
  62:	0f b6 09             	movzbl (%ecx),%ecx
  65:	88 0b                	mov    %cl,(%ebx)
  67:	84 c9                	test   %cl,%cl
  69:	75 ed                	jne    58 <strcpy+0xd>
    ;
  return os;
}
  6b:	89 f0                	mov    %esi,%eax
  6d:	5b                   	pop    %ebx
  6e:	5e                   	pop    %esi
  6f:	5d                   	pop    %ebp
  70:	c3                   	ret    

00000071 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7a:	eb 06                	jmp    82 <strcmp+0x11>
    p++, q++;
  7c:	83 c1 01             	add    $0x1,%ecx
  7f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  82:	0f b6 01             	movzbl (%ecx),%eax
  85:	84 c0                	test   %al,%al
  87:	74 04                	je     8d <strcmp+0x1c>
  89:	3a 02                	cmp    (%edx),%al
  8b:	74 ef                	je     7c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8d:	0f b6 c0             	movzbl %al,%eax
  90:	0f b6 12             	movzbl (%edx),%edx
  93:	29 d0                	sub    %edx,%eax
}
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    

00000097 <strlen>:

uint
strlen(const char *s)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  9d:	b8 00 00 00 00       	mov    $0x0,%eax
  a2:	eb 03                	jmp    a7 <strlen+0x10>
  a4:	83 c0 01             	add    $0x1,%eax
  a7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  ab:	75 f7                	jne    a4 <strlen+0xd>
    ;
  return n;
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <memset>:

void*
memset(void *dst, int c, uint n)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	57                   	push   %edi
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b6:	89 d7                	mov    %edx,%edi
  b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	fc                   	cld    
  bf:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c1:	89 d0                	mov    %edx,%eax
  c3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strchr>:

char*
strchr(const char *s, char c)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d2:	eb 03                	jmp    d7 <strchr+0xf>
  d4:	83 c0 01             	add    $0x1,%eax
  d7:	0f b6 10             	movzbl (%eax),%edx
  da:	84 d2                	test   %dl,%dl
  dc:	74 06                	je     e4 <strchr+0x1c>
    if(*s == c)
  de:	38 ca                	cmp    %cl,%dl
  e0:	75 f2                	jne    d4 <strchr+0xc>
  e2:	eb 05                	jmp    e9 <strchr+0x21>
      return (char*)s;
  return 0;
  e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e9:	5d                   	pop    %ebp
  ea:	c3                   	ret    

000000eb <gets>:

char*
gets(char *buf, int max)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	57                   	push   %edi
  ef:	56                   	push   %esi
  f0:	53                   	push   %ebx
  f1:	83 ec 1c             	sub    $0x1c,%esp
  f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  fc:	89 de                	mov    %ebx,%esi
  fe:	83 c3 01             	add    $0x1,%ebx
 101:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 104:	7d 2e                	jge    134 <gets+0x49>
    cc = read(0, &c, 1);
 106:	83 ec 04             	sub    $0x4,%esp
 109:	6a 01                	push   $0x1
 10b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 10e:	50                   	push   %eax
 10f:	6a 00                	push   $0x0
 111:	e8 ec 00 00 00       	call   202 <read>
    if(cc < 1)
 116:	83 c4 10             	add    $0x10,%esp
 119:	85 c0                	test   %eax,%eax
 11b:	7e 17                	jle    134 <gets+0x49>
      break;
    buf[i++] = c;
 11d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 121:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 124:	3c 0a                	cmp    $0xa,%al
 126:	0f 94 c2             	sete   %dl
 129:	3c 0d                	cmp    $0xd,%al
 12b:	0f 94 c0             	sete   %al
 12e:	08 c2                	or     %al,%dl
 130:	74 ca                	je     fc <gets+0x11>
    buf[i++] = c;
 132:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 134:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 138:	89 f8                	mov    %edi,%eax
 13a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13d:	5b                   	pop    %ebx
 13e:	5e                   	pop    %esi
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <stat>:

int
stat(const char *n, struct stat *st)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	56                   	push   %esi
 146:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 147:	83 ec 08             	sub    $0x8,%esp
 14a:	6a 00                	push   $0x0
 14c:	ff 75 08             	push   0x8(%ebp)
 14f:	e8 d6 00 00 00       	call   22a <open>
  if(fd < 0)
 154:	83 c4 10             	add    $0x10,%esp
 157:	85 c0                	test   %eax,%eax
 159:	78 24                	js     17f <stat+0x3d>
 15b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15d:	83 ec 08             	sub    $0x8,%esp
 160:	ff 75 0c             	push   0xc(%ebp)
 163:	50                   	push   %eax
 164:	e8 d9 00 00 00       	call   242 <fstat>
 169:	89 c6                	mov    %eax,%esi
  close(fd);
 16b:	89 1c 24             	mov    %ebx,(%esp)
 16e:	e8 9f 00 00 00       	call   212 <close>
  return r;
 173:	83 c4 10             	add    $0x10,%esp
}
 176:	89 f0                	mov    %esi,%eax
 178:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17b:	5b                   	pop    %ebx
 17c:	5e                   	pop    %esi
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
    return -1;
 17f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 184:	eb f0                	jmp    176 <stat+0x34>

00000186 <atoi>:

int
atoi(const char *s)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	53                   	push   %ebx
 18a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 18d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 192:	eb 10                	jmp    1a4 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 194:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 197:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 19a:	83 c1 01             	add    $0x1,%ecx
 19d:	0f be c0             	movsbl %al,%eax
 1a0:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a4:	0f b6 01             	movzbl (%ecx),%eax
 1a7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1aa:	80 fb 09             	cmp    $0x9,%bl
 1ad:	76 e5                	jbe    194 <atoi+0xe>
  return n;
}
 1af:	89 d0                	mov    %edx,%eax
 1b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	56                   	push   %esi
 1ba:	53                   	push   %ebx
 1bb:	8b 75 08             	mov    0x8(%ebp),%esi
 1be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c1:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c4:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1c6:	eb 0d                	jmp    1d5 <memmove+0x1f>
    *dst++ = *src++;
 1c8:	0f b6 01             	movzbl (%ecx),%eax
 1cb:	88 02                	mov    %al,(%edx)
 1cd:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d3:	89 d8                	mov    %ebx,%eax
 1d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1d8:	85 c0                	test   %eax,%eax
 1da:	7f ec                	jg     1c8 <memmove+0x12>
  return vdst;
}
 1dc:	89 f0                	mov    %esi,%eax
 1de:	5b                   	pop    %ebx
 1df:	5e                   	pop    %esi
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    

000001e2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e2:	b8 01 00 00 00       	mov    $0x1,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <exit>:
SYSCALL(exit)
 1ea:	b8 02 00 00 00       	mov    $0x2,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <wait>:
SYSCALL(wait)
 1f2:	b8 03 00 00 00       	mov    $0x3,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <pipe>:
SYSCALL(pipe)
 1fa:	b8 04 00 00 00       	mov    $0x4,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <read>:
SYSCALL(read)
 202:	b8 05 00 00 00       	mov    $0x5,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <write>:
SYSCALL(write)
 20a:	b8 10 00 00 00       	mov    $0x10,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <close>:
SYSCALL(close)
 212:	b8 15 00 00 00       	mov    $0x15,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <kill>:
SYSCALL(kill)
 21a:	b8 06 00 00 00       	mov    $0x6,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <exec>:
SYSCALL(exec)
 222:	b8 07 00 00 00       	mov    $0x7,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <open>:
SYSCALL(open)
 22a:	b8 0f 00 00 00       	mov    $0xf,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <mknod>:
SYSCALL(mknod)
 232:	b8 11 00 00 00       	mov    $0x11,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <unlink>:
SYSCALL(unlink)
 23a:	b8 12 00 00 00       	mov    $0x12,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <fstat>:
SYSCALL(fstat)
 242:	b8 08 00 00 00       	mov    $0x8,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <link>:
SYSCALL(link)
 24a:	b8 13 00 00 00       	mov    $0x13,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <mkdir>:
SYSCALL(mkdir)
 252:	b8 14 00 00 00       	mov    $0x14,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <chdir>:
SYSCALL(chdir)
 25a:	b8 09 00 00 00       	mov    $0x9,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <dup>:
SYSCALL(dup)
 262:	b8 0a 00 00 00       	mov    $0xa,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <getpid>:
SYSCALL(getpid)
 26a:	b8 0b 00 00 00       	mov    $0xb,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <sbrk>:
SYSCALL(sbrk)
 272:	b8 0c 00 00 00       	mov    $0xc,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <sleep>:
SYSCALL(sleep)
 27a:	b8 0d 00 00 00       	mov    $0xd,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <uptime>:
SYSCALL(uptime)
 282:	b8 0e 00 00 00       	mov    $0xe,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <settickets>:
SYSCALL(settickets)
 28a:	b8 16 00 00 00       	mov    $0x16,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <getpinfo>:
SYSCALL(getpinfo)
 292:	b8 17 00 00 00       	mov    $0x17,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <mprotect>:
SYSCALL(mprotect)
 29a:	b8 18 00 00 00       	mov    $0x18,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <munprotect>:
SYSCALL(munprotect)
 2a2:	b8 19 00 00 00       	mov    $0x19,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	83 ec 1c             	sub    $0x1c,%esp
 2b0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b3:	6a 01                	push   $0x1
 2b5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b8:	52                   	push   %edx
 2b9:	50                   	push   %eax
 2ba:	e8 4b ff ff ff       	call   20a <write>
}
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	56                   	push   %esi
 2c9:	53                   	push   %ebx
 2ca:	83 ec 2c             	sub    $0x2c,%esp
 2cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d0:	89 d0                	mov    %edx,%eax
 2d2:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d8:	0f 95 c1             	setne  %cl
 2db:	c1 ea 1f             	shr    $0x1f,%edx
 2de:	84 d1                	test   %dl,%cl
 2e0:	74 44                	je     326 <printint+0x62>
    neg = 1;
    x = -xx;
 2e2:	f7 d8                	neg    %eax
 2e4:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2e6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f2:	89 c8                	mov    %ecx,%eax
 2f4:	ba 00 00 00 00       	mov    $0x0,%edx
 2f9:	f7 f6                	div    %esi
 2fb:	89 df                	mov    %ebx,%edi
 2fd:	83 c3 01             	add    $0x1,%ebx
 300:	0f b6 92 8c 06 00 00 	movzbl 0x68c(%edx),%edx
 307:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 30b:	89 ca                	mov    %ecx,%edx
 30d:	89 c1                	mov    %eax,%ecx
 30f:	39 d6                	cmp    %edx,%esi
 311:	76 df                	jbe    2f2 <printint+0x2e>
  if(neg)
 313:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 317:	74 31                	je     34a <printint+0x86>
    buf[i++] = '-';
 319:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 31e:	8d 5f 02             	lea    0x2(%edi),%ebx
 321:	8b 75 d0             	mov    -0x30(%ebp),%esi
 324:	eb 17                	jmp    33d <printint+0x79>
    x = xx;
 326:	89 c1                	mov    %eax,%ecx
  neg = 0;
 328:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 32f:	eb bc                	jmp    2ed <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 331:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 336:	89 f0                	mov    %esi,%eax
 338:	e8 6d ff ff ff       	call   2aa <putc>
  while(--i >= 0)
 33d:	83 eb 01             	sub    $0x1,%ebx
 340:	79 ef                	jns    331 <printint+0x6d>
}
 342:	83 c4 2c             	add    $0x2c,%esp
 345:	5b                   	pop    %ebx
 346:	5e                   	pop    %esi
 347:	5f                   	pop    %edi
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    
 34a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 34d:	eb ee                	jmp    33d <printint+0x79>

0000034f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	57                   	push   %edi
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
 355:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 358:	8d 45 10             	lea    0x10(%ebp),%eax
 35b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 35e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 363:	bb 00 00 00 00       	mov    $0x0,%ebx
 368:	eb 14                	jmp    37e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 36a:	89 fa                	mov    %edi,%edx
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	e8 36 ff ff ff       	call   2aa <putc>
 374:	eb 05                	jmp    37b <printf+0x2c>
      }
    } else if(state == '%'){
 376:	83 fe 25             	cmp    $0x25,%esi
 379:	74 25                	je     3a0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 37b:	83 c3 01             	add    $0x1,%ebx
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 385:	84 c0                	test   %al,%al
 387:	0f 84 20 01 00 00    	je     4ad <printf+0x15e>
    c = fmt[i] & 0xff;
 38d:	0f be f8             	movsbl %al,%edi
 390:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 393:	85 f6                	test   %esi,%esi
 395:	75 df                	jne    376 <printf+0x27>
      if(c == '%'){
 397:	83 f8 25             	cmp    $0x25,%eax
 39a:	75 ce                	jne    36a <printf+0x1b>
        state = '%';
 39c:	89 c6                	mov    %eax,%esi
 39e:	eb db                	jmp    37b <printf+0x2c>
      if(c == 'd'){
 3a0:	83 f8 25             	cmp    $0x25,%eax
 3a3:	0f 84 cf 00 00 00    	je     478 <printf+0x129>
 3a9:	0f 8c dd 00 00 00    	jl     48c <printf+0x13d>
 3af:	83 f8 78             	cmp    $0x78,%eax
 3b2:	0f 8f d4 00 00 00    	jg     48c <printf+0x13d>
 3b8:	83 f8 63             	cmp    $0x63,%eax
 3bb:	0f 8c cb 00 00 00    	jl     48c <printf+0x13d>
 3c1:	83 e8 63             	sub    $0x63,%eax
 3c4:	83 f8 15             	cmp    $0x15,%eax
 3c7:	0f 87 bf 00 00 00    	ja     48c <printf+0x13d>
 3cd:	ff 24 85 34 06 00 00 	jmp    *0x634(,%eax,4)
        printint(fd, *ap, 10, 1);
 3d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d7:	8b 17                	mov    (%edi),%edx
 3d9:	83 ec 0c             	sub    $0xc,%esp
 3dc:	6a 01                	push   $0x1
 3de:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	e8 d9 fe ff ff       	call   2c4 <printint>
        ap++;
 3eb:	83 c7 04             	add    $0x4,%edi
 3ee:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3f4:	be 00 00 00 00       	mov    $0x0,%esi
 3f9:	eb 80                	jmp    37b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3fe:	8b 17                	mov    (%edi),%edx
 400:	83 ec 0c             	sub    $0xc,%esp
 403:	6a 00                	push   $0x0
 405:	b9 10 00 00 00       	mov    $0x10,%ecx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	e8 b2 fe ff ff       	call   2c4 <printint>
        ap++;
 412:	83 c7 04             	add    $0x4,%edi
 415:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 418:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41b:	be 00 00 00 00       	mov    $0x0,%esi
 420:	e9 56 ff ff ff       	jmp    37b <printf+0x2c>
        s = (char*)*ap;
 425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 428:	8b 30                	mov    (%eax),%esi
        ap++;
 42a:	83 c0 04             	add    $0x4,%eax
 42d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 430:	85 f6                	test   %esi,%esi
 432:	75 15                	jne    449 <printf+0xfa>
          s = "(null)";
 434:	be 2b 06 00 00       	mov    $0x62b,%esi
 439:	eb 0e                	jmp    449 <printf+0xfa>
          putc(fd, *s);
 43b:	0f be d2             	movsbl %dl,%edx
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	e8 64 fe ff ff       	call   2aa <putc>
          s++;
 446:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 449:	0f b6 16             	movzbl (%esi),%edx
 44c:	84 d2                	test   %dl,%dl
 44e:	75 eb                	jne    43b <printf+0xec>
      state = 0;
 450:	be 00 00 00 00       	mov    $0x0,%esi
 455:	e9 21 ff ff ff       	jmp    37b <printf+0x2c>
        putc(fd, *ap);
 45a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 45d:	0f be 17             	movsbl (%edi),%edx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	e8 42 fe ff ff       	call   2aa <putc>
        ap++;
 468:	83 c7 04             	add    $0x4,%edi
 46b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
 473:	e9 03 ff ff ff       	jmp    37b <printf+0x2c>
        putc(fd, c);
 478:	89 fa                	mov    %edi,%edx
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	e8 28 fe ff ff       	call   2aa <putc>
      state = 0;
 482:	be 00 00 00 00       	mov    $0x0,%esi
 487:	e9 ef fe ff ff       	jmp    37b <printf+0x2c>
        putc(fd, '%');
 48c:	ba 25 00 00 00       	mov    $0x25,%edx
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	e8 11 fe ff ff       	call   2aa <putc>
        putc(fd, c);
 499:	89 fa                	mov    %edi,%edx
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	e8 07 fe ff ff       	call   2aa <putc>
      state = 0;
 4a3:	be 00 00 00 00       	mov    $0x0,%esi
 4a8:	e9 ce fe ff ff       	jmp    37b <printf+0x2c>
    }
  }
}
 4ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    

000004b5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b5:	55                   	push   %ebp
 4b6:	89 e5                	mov    %esp,%ebp
 4b8:	57                   	push   %edi
 4b9:	56                   	push   %esi
 4ba:	53                   	push   %ebx
 4bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c1:	a1 2c 09 00 00       	mov    0x92c,%eax
 4c6:	eb 02                	jmp    4ca <free+0x15>
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	39 c8                	cmp    %ecx,%eax
 4cc:	73 04                	jae    4d2 <free+0x1d>
 4ce:	39 08                	cmp    %ecx,(%eax)
 4d0:	77 12                	ja     4e4 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d2:	8b 10                	mov    (%eax),%edx
 4d4:	39 c2                	cmp    %eax,%edx
 4d6:	77 f0                	ja     4c8 <free+0x13>
 4d8:	39 c8                	cmp    %ecx,%eax
 4da:	72 08                	jb     4e4 <free+0x2f>
 4dc:	39 ca                	cmp    %ecx,%edx
 4de:	77 04                	ja     4e4 <free+0x2f>
 4e0:	89 d0                	mov    %edx,%eax
 4e2:	eb e6                	jmp    4ca <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4e7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ea:	8b 10                	mov    (%eax),%edx
 4ec:	39 d7                	cmp    %edx,%edi
 4ee:	74 19                	je     509 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f3:	8b 50 04             	mov    0x4(%eax),%edx
 4f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4f9:	39 ce                	cmp    %ecx,%esi
 4fb:	74 1b                	je     518 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4fd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4ff:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 504:	5b                   	pop    %ebx
 505:	5e                   	pop    %esi
 506:	5f                   	pop    %edi
 507:	5d                   	pop    %ebp
 508:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 509:	03 72 04             	add    0x4(%edx),%esi
 50c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 50f:	8b 10                	mov    (%eax),%edx
 511:	8b 12                	mov    (%edx),%edx
 513:	89 53 f8             	mov    %edx,-0x8(%ebx)
 516:	eb db                	jmp    4f3 <free+0x3e>
    p->s.size += bp->s.size;
 518:	03 53 fc             	add    -0x4(%ebx),%edx
 51b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 51e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 521:	89 10                	mov    %edx,(%eax)
 523:	eb da                	jmp    4ff <free+0x4a>

00000525 <morecore>:

static Header*
morecore(uint nu)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	53                   	push   %ebx
 529:	83 ec 04             	sub    $0x4,%esp
 52c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 52e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 533:	77 05                	ja     53a <morecore+0x15>
    nu = 4096;
 535:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 53a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 541:	83 ec 0c             	sub    $0xc,%esp
 544:	50                   	push   %eax
 545:	e8 28 fd ff ff       	call   272 <sbrk>
  if(p == (char*)-1)
 54a:	83 c4 10             	add    $0x10,%esp
 54d:	83 f8 ff             	cmp    $0xffffffff,%eax
 550:	74 1c                	je     56e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 552:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 555:	83 c0 08             	add    $0x8,%eax
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	50                   	push   %eax
 55c:	e8 54 ff ff ff       	call   4b5 <free>
  return freep;
 561:	a1 2c 09 00 00       	mov    0x92c,%eax
 566:	83 c4 10             	add    $0x10,%esp
}
 569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56c:	c9                   	leave  
 56d:	c3                   	ret    
    return 0;
 56e:	b8 00 00 00 00       	mov    $0x0,%eax
 573:	eb f4                	jmp    569 <morecore+0x44>

00000575 <malloc>:

void*
malloc(uint nbytes)
{
 575:	55                   	push   %ebp
 576:	89 e5                	mov    %esp,%ebp
 578:	53                   	push   %ebx
 579:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	8d 58 07             	lea    0x7(%eax),%ebx
 582:	c1 eb 03             	shr    $0x3,%ebx
 585:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 588:	8b 0d 2c 09 00 00    	mov    0x92c,%ecx
 58e:	85 c9                	test   %ecx,%ecx
 590:	74 04                	je     596 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 592:	8b 01                	mov    (%ecx),%eax
 594:	eb 4a                	jmp    5e0 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 596:	c7 05 2c 09 00 00 30 	movl   $0x930,0x92c
 59d:	09 00 00 
 5a0:	c7 05 30 09 00 00 30 	movl   $0x930,0x930
 5a7:	09 00 00 
    base.s.size = 0;
 5aa:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 5b1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5b4:	b9 30 09 00 00       	mov    $0x930,%ecx
 5b9:	eb d7                	jmp    592 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5bb:	74 19                	je     5d6 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5bd:	29 da                	sub    %ebx,%edx
 5bf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5c5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5c8:	89 0d 2c 09 00 00    	mov    %ecx,0x92c
      return (void*)(p + 1);
 5ce:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d4:	c9                   	leave  
 5d5:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5d6:	8b 10                	mov    (%eax),%edx
 5d8:	89 11                	mov    %edx,(%ecx)
 5da:	eb ec                	jmp    5c8 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5dc:	89 c1                	mov    %eax,%ecx
 5de:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e0:	8b 50 04             	mov    0x4(%eax),%edx
 5e3:	39 da                	cmp    %ebx,%edx
 5e5:	73 d4                	jae    5bb <malloc+0x46>
    if(p == freep)
 5e7:	39 05 2c 09 00 00    	cmp    %eax,0x92c
 5ed:	75 ed                	jne    5dc <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5ef:	89 d8                	mov    %ebx,%eax
 5f1:	e8 2f ff ff ff       	call   525 <morecore>
 5f6:	85 c0                	test   %eax,%eax
 5f8:	75 e2                	jne    5dc <malloc+0x67>
 5fa:	eb d5                	jmp    5d1 <malloc+0x5c>
