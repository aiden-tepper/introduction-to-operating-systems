
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 20 0a 00 00       	push   $0xa20
  15:	56                   	push   %esi
  16:	e8 94 02 00 00       	call   2af <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 20 0a 00 00       	push   $0xa20
  2d:	6a 01                	push   $0x1
  2f:	e8 83 02 00 00       	call   2b7 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 ac 06 00 00       	push   $0x6ac
  43:	6a 01                	push   $0x1
  45:	e8 b2 03 00 00       	call   3fc <printf>
      exit();
  4a:	e8 48 02 00 00       	call   297 <exit>
    }
  }
  if(n < 0){
  4f:	78 07                	js     58 <cat+0x58>
    printf(1, "cat: read error\n");
    exit();
  }
}
  51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  54:	5b                   	pop    %ebx
  55:	5e                   	pop    %esi
  56:	5d                   	pop    %ebp
  57:	c3                   	ret    
    printf(1, "cat: read error\n");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 be 06 00 00       	push   $0x6be
  60:	6a 01                	push   $0x1
  62:	e8 95 03 00 00       	call   3fc <printf>
    exit();
  67:	e8 2b 02 00 00       	call   297 <exit>

0000006c <main>:

int
main(int argc, char *argv[])
{
  6c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  70:	83 e4 f0             	and    $0xfffffff0,%esp
  73:	ff 71 fc             	push   -0x4(%ecx)
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	56                   	push   %esi
  7b:	53                   	push   %ebx
  7c:	51                   	push   %ecx
  7d:	83 ec 18             	sub    $0x18,%esp
  80:	8b 01                	mov    (%ecx),%eax
  82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  85:	8b 51 04             	mov    0x4(%ecx),%edx
  88:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  8b:	83 f8 01             	cmp    $0x1,%eax
  8e:	7e 07                	jle    97 <main+0x2b>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  90:	be 01 00 00 00       	mov    $0x1,%esi
  95:	eb 26                	jmp    bd <main+0x51>
    cat(0);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 00                	push   $0x0
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 f1 01 00 00       	call   297 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	50                   	push   %eax
  aa:	e8 51 ff ff ff       	call   0 <cat>
    close(fd);
  af:	89 1c 24             	mov    %ebx,(%esp)
  b2:	e8 08 02 00 00       	call   2bf <close>
  for(i = 1; i < argc; i++){
  b7:	83 c6 01             	add    $0x1,%esi
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  c0:	7d 31                	jge    f3 <main+0x87>
    if((fd = open(argv[i], 0)) < 0){
  c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	6a 00                	push   $0x0
  cd:	ff 37                	push   (%edi)
  cf:	e8 03 02 00 00       	call   2d7 <open>
  d4:	89 c3                	mov    %eax,%ebx
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	85 c0                	test   %eax,%eax
  db:	79 c9                	jns    a6 <main+0x3a>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 37                	push   (%edi)
  e2:	68 cf 06 00 00       	push   $0x6cf
  e7:	6a 01                	push   $0x1
  e9:	e8 0e 03 00 00       	call   3fc <printf>
      exit();
  ee:	e8 a4 01 00 00       	call   297 <exit>
  }
  exit();
  f3:	e8 9f 01 00 00       	call   297 <exit>

000000f8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	56                   	push   %esi
  fc:	53                   	push   %ebx
  fd:	8b 75 08             	mov    0x8(%ebp),%esi
 100:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 103:	89 f0                	mov    %esi,%eax
 105:	89 d1                	mov    %edx,%ecx
 107:	83 c2 01             	add    $0x1,%edx
 10a:	89 c3                	mov    %eax,%ebx
 10c:	83 c0 01             	add    $0x1,%eax
 10f:	0f b6 09             	movzbl (%ecx),%ecx
 112:	88 0b                	mov    %cl,(%ebx)
 114:	84 c9                	test   %cl,%cl
 116:	75 ed                	jne    105 <strcpy+0xd>
    ;
  return os;
}
 118:	89 f0                	mov    %esi,%eax
 11a:	5b                   	pop    %ebx
 11b:	5e                   	pop    %esi
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    

0000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 127:	eb 06                	jmp    12f <strcmp+0x11>
    p++, q++;
 129:	83 c1 01             	add    $0x1,%ecx
 12c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 12f:	0f b6 01             	movzbl (%ecx),%eax
 132:	84 c0                	test   %al,%al
 134:	74 04                	je     13a <strcmp+0x1c>
 136:	3a 02                	cmp    (%edx),%al
 138:	74 ef                	je     129 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 13a:	0f b6 c0             	movzbl %al,%eax
 13d:	0f b6 12             	movzbl (%edx),%edx
 140:	29 d0                	sub    %edx,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

00000144 <strlen>:

uint
strlen(const char *s)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 14a:	b8 00 00 00 00       	mov    $0x0,%eax
 14f:	eb 03                	jmp    154 <strlen+0x10>
 151:	83 c0 01             	add    $0x1,%eax
 154:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 158:	75 f7                	jne    151 <strlen+0xd>
    ;
  return n;
}
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    

0000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	57                   	push   %edi
 160:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 163:	89 d7                	mov    %edx,%edi
 165:	8b 4d 10             	mov    0x10(%ebp),%ecx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	fc                   	cld    
 16c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 16e:	89 d0                	mov    %edx,%eax
 170:	8b 7d fc             	mov    -0x4(%ebp),%edi
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <strchr>:

char*
strchr(const char *s, char c)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 17f:	eb 03                	jmp    184 <strchr+0xf>
 181:	83 c0 01             	add    $0x1,%eax
 184:	0f b6 10             	movzbl (%eax),%edx
 187:	84 d2                	test   %dl,%dl
 189:	74 06                	je     191 <strchr+0x1c>
    if(*s == c)
 18b:	38 ca                	cmp    %cl,%dl
 18d:	75 f2                	jne    181 <strchr+0xc>
 18f:	eb 05                	jmp    196 <strchr+0x21>
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	57                   	push   %edi
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	83 ec 1c             	sub    $0x1c,%esp
 1a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	bb 00 00 00 00       	mov    $0x0,%ebx
 1a9:	89 de                	mov    %ebx,%esi
 1ab:	83 c3 01             	add    $0x1,%ebx
 1ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b1:	7d 2e                	jge    1e1 <gets+0x49>
    cc = read(0, &c, 1);
 1b3:	83 ec 04             	sub    $0x4,%esp
 1b6:	6a 01                	push   $0x1
 1b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1bb:	50                   	push   %eax
 1bc:	6a 00                	push   $0x0
 1be:	e8 ec 00 00 00       	call   2af <read>
    if(cc < 1)
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
 1c8:	7e 17                	jle    1e1 <gets+0x49>
      break;
    buf[i++] = c;
 1ca:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ce:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	0f 94 c2             	sete   %dl
 1d6:	3c 0d                	cmp    $0xd,%al
 1d8:	0f 94 c0             	sete   %al
 1db:	08 c2                	or     %al,%dl
 1dd:	74 ca                	je     1a9 <gets+0x11>
    buf[i++] = c;
 1df:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1e1:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1e5:	89 f8                	mov    %edi,%eax
 1e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ea:	5b                   	pop    %ebx
 1eb:	5e                   	pop    %esi
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(const char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	56                   	push   %esi
 1f3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	83 ec 08             	sub    $0x8,%esp
 1f7:	6a 00                	push   $0x0
 1f9:	ff 75 08             	push   0x8(%ebp)
 1fc:	e8 d6 00 00 00       	call   2d7 <open>
  if(fd < 0)
 201:	83 c4 10             	add    $0x10,%esp
 204:	85 c0                	test   %eax,%eax
 206:	78 24                	js     22c <stat+0x3d>
 208:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20a:	83 ec 08             	sub    $0x8,%esp
 20d:	ff 75 0c             	push   0xc(%ebp)
 210:	50                   	push   %eax
 211:	e8 d9 00 00 00       	call   2ef <fstat>
 216:	89 c6                	mov    %eax,%esi
  close(fd);
 218:	89 1c 24             	mov    %ebx,(%esp)
 21b:	e8 9f 00 00 00       	call   2bf <close>
  return r;
 220:	83 c4 10             	add    $0x10,%esp
}
 223:	89 f0                	mov    %esi,%eax
 225:	8d 65 f8             	lea    -0x8(%ebp),%esp
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    
    return -1;
 22c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 231:	eb f0                	jmp    223 <stat+0x34>

00000233 <atoi>:

int
atoi(const char *s)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	53                   	push   %ebx
 237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 23a:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 23f:	eb 10                	jmp    251 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 241:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 244:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 247:	83 c1 01             	add    $0x1,%ecx
 24a:	0f be c0             	movsbl %al,%eax
 24d:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 251:	0f b6 01             	movzbl (%ecx),%eax
 254:	8d 58 d0             	lea    -0x30(%eax),%ebx
 257:	80 fb 09             	cmp    $0x9,%bl
 25a:	76 e5                	jbe    241 <atoi+0xe>
  return n;
}
 25c:	89 d0                	mov    %edx,%eax
 25e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	56                   	push   %esi
 267:	53                   	push   %ebx
 268:	8b 75 08             	mov    0x8(%ebp),%esi
 26b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 26e:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 271:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 273:	eb 0d                	jmp    282 <memmove+0x1f>
    *dst++ = *src++;
 275:	0f b6 01             	movzbl (%ecx),%eax
 278:	88 02                	mov    %al,(%edx)
 27a:	8d 49 01             	lea    0x1(%ecx),%ecx
 27d:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 280:	89 d8                	mov    %ebx,%eax
 282:	8d 58 ff             	lea    -0x1(%eax),%ebx
 285:	85 c0                	test   %eax,%eax
 287:	7f ec                	jg     275 <memmove+0x12>
  return vdst;
}
 289:	89 f0                	mov    %esi,%eax
 28b:	5b                   	pop    %ebx
 28c:	5e                   	pop    %esi
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    

0000028f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28f:	b8 01 00 00 00       	mov    $0x1,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <exit>:
SYSCALL(exit)
 297:	b8 02 00 00 00       	mov    $0x2,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <wait>:
SYSCALL(wait)
 29f:	b8 03 00 00 00       	mov    $0x3,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <pipe>:
SYSCALL(pipe)
 2a7:	b8 04 00 00 00       	mov    $0x4,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <read>:
SYSCALL(read)
 2af:	b8 05 00 00 00       	mov    $0x5,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <write>:
SYSCALL(write)
 2b7:	b8 10 00 00 00       	mov    $0x10,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <close>:
SYSCALL(close)
 2bf:	b8 15 00 00 00       	mov    $0x15,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <kill>:
SYSCALL(kill)
 2c7:	b8 06 00 00 00       	mov    $0x6,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exec>:
SYSCALL(exec)
 2cf:	b8 07 00 00 00       	mov    $0x7,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <open>:
SYSCALL(open)
 2d7:	b8 0f 00 00 00       	mov    $0xf,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <mknod>:
SYSCALL(mknod)
 2df:	b8 11 00 00 00       	mov    $0x11,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <unlink>:
SYSCALL(unlink)
 2e7:	b8 12 00 00 00       	mov    $0x12,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <fstat>:
SYSCALL(fstat)
 2ef:	b8 08 00 00 00       	mov    $0x8,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <link>:
SYSCALL(link)
 2f7:	b8 13 00 00 00       	mov    $0x13,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <mkdir>:
SYSCALL(mkdir)
 2ff:	b8 14 00 00 00       	mov    $0x14,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <chdir>:
SYSCALL(chdir)
 307:	b8 09 00 00 00       	mov    $0x9,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <dup>:
SYSCALL(dup)
 30f:	b8 0a 00 00 00       	mov    $0xa,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <getpid>:
SYSCALL(getpid)
 317:	b8 0b 00 00 00       	mov    $0xb,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <sbrk>:
SYSCALL(sbrk)
 31f:	b8 0c 00 00 00       	mov    $0xc,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <sleep>:
SYSCALL(sleep)
 327:	b8 0d 00 00 00       	mov    $0xd,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <uptime>:
SYSCALL(uptime)
 32f:	b8 0e 00 00 00       	mov    $0xe,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <settickets>:
SYSCALL(settickets)
 337:	b8 16 00 00 00       	mov    $0x16,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <getpinfo>:
SYSCALL(getpinfo)
 33f:	b8 17 00 00 00       	mov    $0x17,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <mprotect>:
SYSCALL(mprotect)
 347:	b8 18 00 00 00       	mov    $0x18,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <munprotect>:
SYSCALL(munprotect)
 34f:	b8 19 00 00 00       	mov    $0x19,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	83 ec 1c             	sub    $0x1c,%esp
 35d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 360:	6a 01                	push   $0x1
 362:	8d 55 f4             	lea    -0xc(%ebp),%edx
 365:	52                   	push   %edx
 366:	50                   	push   %eax
 367:	e8 4b ff ff ff       	call   2b7 <write>
}
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	56                   	push   %esi
 376:	53                   	push   %ebx
 377:	83 ec 2c             	sub    $0x2c,%esp
 37a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 37d:	89 d0                	mov    %edx,%eax
 37f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 385:	0f 95 c1             	setne  %cl
 388:	c1 ea 1f             	shr    $0x1f,%edx
 38b:	84 d1                	test   %dl,%cl
 38d:	74 44                	je     3d3 <printint+0x62>
    neg = 1;
    x = -xx;
 38f:	f7 d8                	neg    %eax
 391:	89 c1                	mov    %eax,%ecx
    neg = 1;
 393:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 39a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 39f:	89 c8                	mov    %ecx,%eax
 3a1:	ba 00 00 00 00       	mov    $0x0,%edx
 3a6:	f7 f6                	div    %esi
 3a8:	89 df                	mov    %ebx,%edi
 3aa:	83 c3 01             	add    $0x1,%ebx
 3ad:	0f b6 92 44 07 00 00 	movzbl 0x744(%edx),%edx
 3b4:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3b8:	89 ca                	mov    %ecx,%edx
 3ba:	89 c1                	mov    %eax,%ecx
 3bc:	39 d6                	cmp    %edx,%esi
 3be:	76 df                	jbe    39f <printint+0x2e>
  if(neg)
 3c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3c4:	74 31                	je     3f7 <printint+0x86>
    buf[i++] = '-';
 3c6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3cb:	8d 5f 02             	lea    0x2(%edi),%ebx
 3ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3d1:	eb 17                	jmp    3ea <printint+0x79>
    x = xx;
 3d3:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3d5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3dc:	eb bc                	jmp    39a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3de:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e3:	89 f0                	mov    %esi,%eax
 3e5:	e8 6d ff ff ff       	call   357 <putc>
  while(--i >= 0)
 3ea:	83 eb 01             	sub    $0x1,%ebx
 3ed:	79 ef                	jns    3de <printint+0x6d>
}
 3ef:	83 c4 2c             	add    $0x2c,%esp
 3f2:	5b                   	pop    %ebx
 3f3:	5e                   	pop    %esi
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3fa:	eb ee                	jmp    3ea <printint+0x79>

000003fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	57                   	push   %edi
 400:	56                   	push   %esi
 401:	53                   	push   %ebx
 402:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 405:	8d 45 10             	lea    0x10(%ebp),%eax
 408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 40b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 410:	bb 00 00 00 00       	mov    $0x0,%ebx
 415:	eb 14                	jmp    42b <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 417:	89 fa                	mov    %edi,%edx
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	e8 36 ff ff ff       	call   357 <putc>
 421:	eb 05                	jmp    428 <printf+0x2c>
      }
    } else if(state == '%'){
 423:	83 fe 25             	cmp    $0x25,%esi
 426:	74 25                	je     44d <printf+0x51>
  for(i = 0; fmt[i]; i++){
 428:	83 c3 01             	add    $0x1,%ebx
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 432:	84 c0                	test   %al,%al
 434:	0f 84 20 01 00 00    	je     55a <printf+0x15e>
    c = fmt[i] & 0xff;
 43a:	0f be f8             	movsbl %al,%edi
 43d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 440:	85 f6                	test   %esi,%esi
 442:	75 df                	jne    423 <printf+0x27>
      if(c == '%'){
 444:	83 f8 25             	cmp    $0x25,%eax
 447:	75 ce                	jne    417 <printf+0x1b>
        state = '%';
 449:	89 c6                	mov    %eax,%esi
 44b:	eb db                	jmp    428 <printf+0x2c>
      if(c == 'd'){
 44d:	83 f8 25             	cmp    $0x25,%eax
 450:	0f 84 cf 00 00 00    	je     525 <printf+0x129>
 456:	0f 8c dd 00 00 00    	jl     539 <printf+0x13d>
 45c:	83 f8 78             	cmp    $0x78,%eax
 45f:	0f 8f d4 00 00 00    	jg     539 <printf+0x13d>
 465:	83 f8 63             	cmp    $0x63,%eax
 468:	0f 8c cb 00 00 00    	jl     539 <printf+0x13d>
 46e:	83 e8 63             	sub    $0x63,%eax
 471:	83 f8 15             	cmp    $0x15,%eax
 474:	0f 87 bf 00 00 00    	ja     539 <printf+0x13d>
 47a:	ff 24 85 ec 06 00 00 	jmp    *0x6ec(,%eax,4)
        printint(fd, *ap, 10, 1);
 481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 484:	8b 17                	mov    (%edi),%edx
 486:	83 ec 0c             	sub    $0xc,%esp
 489:	6a 01                	push   $0x1
 48b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	e8 d9 fe ff ff       	call   371 <printint>
        ap++;
 498:	83 c7 04             	add    $0x4,%edi
 49b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 49e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a1:	be 00 00 00 00       	mov    $0x0,%esi
 4a6:	eb 80                	jmp    428 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ab:	8b 17                	mov    (%edi),%edx
 4ad:	83 ec 0c             	sub    $0xc,%esp
 4b0:	6a 00                	push   $0x0
 4b2:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	e8 b2 fe ff ff       	call   371 <printint>
        ap++;
 4bf:	83 c7 04             	add    $0x4,%edi
 4c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c8:	be 00 00 00 00       	mov    $0x0,%esi
 4cd:	e9 56 ff ff ff       	jmp    428 <printf+0x2c>
        s = (char*)*ap;
 4d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d5:	8b 30                	mov    (%eax),%esi
        ap++;
 4d7:	83 c0 04             	add    $0x4,%eax
 4da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4dd:	85 f6                	test   %esi,%esi
 4df:	75 15                	jne    4f6 <printf+0xfa>
          s = "(null)";
 4e1:	be e4 06 00 00       	mov    $0x6e4,%esi
 4e6:	eb 0e                	jmp    4f6 <printf+0xfa>
          putc(fd, *s);
 4e8:	0f be d2             	movsbl %dl,%edx
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	e8 64 fe ff ff       	call   357 <putc>
          s++;
 4f3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f6:	0f b6 16             	movzbl (%esi),%edx
 4f9:	84 d2                	test   %dl,%dl
 4fb:	75 eb                	jne    4e8 <printf+0xec>
      state = 0;
 4fd:	be 00 00 00 00       	mov    $0x0,%esi
 502:	e9 21 ff ff ff       	jmp    428 <printf+0x2c>
        putc(fd, *ap);
 507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 50a:	0f be 17             	movsbl (%edi),%edx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	e8 42 fe ff ff       	call   357 <putc>
        ap++;
 515:	83 c7 04             	add    $0x4,%edi
 518:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 51b:	be 00 00 00 00       	mov    $0x0,%esi
 520:	e9 03 ff ff ff       	jmp    428 <printf+0x2c>
        putc(fd, c);
 525:	89 fa                	mov    %edi,%edx
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	e8 28 fe ff ff       	call   357 <putc>
      state = 0;
 52f:	be 00 00 00 00       	mov    $0x0,%esi
 534:	e9 ef fe ff ff       	jmp    428 <printf+0x2c>
        putc(fd, '%');
 539:	ba 25 00 00 00       	mov    $0x25,%edx
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	e8 11 fe ff ff       	call   357 <putc>
        putc(fd, c);
 546:	89 fa                	mov    %edi,%edx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	e8 07 fe ff ff       	call   357 <putc>
      state = 0;
 550:	be 00 00 00 00       	mov    $0x0,%esi
 555:	e9 ce fe ff ff       	jmp    428 <printf+0x2c>
    }
  }
}
 55a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55d:	5b                   	pop    %ebx
 55e:	5e                   	pop    %esi
 55f:	5f                   	pop    %edi
 560:	5d                   	pop    %ebp
 561:	c3                   	ret    

00000562 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 562:	55                   	push   %ebp
 563:	89 e5                	mov    %esp,%ebp
 565:	57                   	push   %edi
 566:	56                   	push   %esi
 567:	53                   	push   %ebx
 568:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 56b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56e:	a1 20 0c 00 00       	mov    0xc20,%eax
 573:	eb 02                	jmp    577 <free+0x15>
 575:	89 d0                	mov    %edx,%eax
 577:	39 c8                	cmp    %ecx,%eax
 579:	73 04                	jae    57f <free+0x1d>
 57b:	39 08                	cmp    %ecx,(%eax)
 57d:	77 12                	ja     591 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57f:	8b 10                	mov    (%eax),%edx
 581:	39 c2                	cmp    %eax,%edx
 583:	77 f0                	ja     575 <free+0x13>
 585:	39 c8                	cmp    %ecx,%eax
 587:	72 08                	jb     591 <free+0x2f>
 589:	39 ca                	cmp    %ecx,%edx
 58b:	77 04                	ja     591 <free+0x2f>
 58d:	89 d0                	mov    %edx,%eax
 58f:	eb e6                	jmp    577 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 591:	8b 73 fc             	mov    -0x4(%ebx),%esi
 594:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 597:	8b 10                	mov    (%eax),%edx
 599:	39 d7                	cmp    %edx,%edi
 59b:	74 19                	je     5b6 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a0:	8b 50 04             	mov    0x4(%eax),%edx
 5a3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a6:	39 ce                	cmp    %ecx,%esi
 5a8:	74 1b                	je     5c5 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5aa:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ac:	a3 20 0c 00 00       	mov    %eax,0xc20
}
 5b1:	5b                   	pop    %ebx
 5b2:	5e                   	pop    %esi
 5b3:	5f                   	pop    %edi
 5b4:	5d                   	pop    %ebp
 5b5:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b6:	03 72 04             	add    0x4(%edx),%esi
 5b9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5bc:	8b 10                	mov    (%eax),%edx
 5be:	8b 12                	mov    (%edx),%edx
 5c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c3:	eb db                	jmp    5a0 <free+0x3e>
    p->s.size += bp->s.size;
 5c5:	03 53 fc             	add    -0x4(%ebx),%edx
 5c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5cb:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ce:	89 10                	mov    %edx,(%eax)
 5d0:	eb da                	jmp    5ac <free+0x4a>

000005d2 <morecore>:

static Header*
morecore(uint nu)
{
 5d2:	55                   	push   %ebp
 5d3:	89 e5                	mov    %esp,%ebp
 5d5:	53                   	push   %ebx
 5d6:	83 ec 04             	sub    $0x4,%esp
 5d9:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5db:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5e0:	77 05                	ja     5e7 <morecore+0x15>
    nu = 4096;
 5e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5e7:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5ee:	83 ec 0c             	sub    $0xc,%esp
 5f1:	50                   	push   %eax
 5f2:	e8 28 fd ff ff       	call   31f <sbrk>
  if(p == (char*)-1)
 5f7:	83 c4 10             	add    $0x10,%esp
 5fa:	83 f8 ff             	cmp    $0xffffffff,%eax
 5fd:	74 1c                	je     61b <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5ff:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 602:	83 c0 08             	add    $0x8,%eax
 605:	83 ec 0c             	sub    $0xc,%esp
 608:	50                   	push   %eax
 609:	e8 54 ff ff ff       	call   562 <free>
  return freep;
 60e:	a1 20 0c 00 00       	mov    0xc20,%eax
 613:	83 c4 10             	add    $0x10,%esp
}
 616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 619:	c9                   	leave  
 61a:	c3                   	ret    
    return 0;
 61b:	b8 00 00 00 00       	mov    $0x0,%eax
 620:	eb f4                	jmp    616 <morecore+0x44>

00000622 <malloc>:

void*
malloc(uint nbytes)
{
 622:	55                   	push   %ebp
 623:	89 e5                	mov    %esp,%ebp
 625:	53                   	push   %ebx
 626:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	8d 58 07             	lea    0x7(%eax),%ebx
 62f:	c1 eb 03             	shr    $0x3,%ebx
 632:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 635:	8b 0d 20 0c 00 00    	mov    0xc20,%ecx
 63b:	85 c9                	test   %ecx,%ecx
 63d:	74 04                	je     643 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63f:	8b 01                	mov    (%ecx),%eax
 641:	eb 4a                	jmp    68d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 643:	c7 05 20 0c 00 00 24 	movl   $0xc24,0xc20
 64a:	0c 00 00 
 64d:	c7 05 24 0c 00 00 24 	movl   $0xc24,0xc24
 654:	0c 00 00 
    base.s.size = 0;
 657:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 65e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 661:	b9 24 0c 00 00       	mov    $0xc24,%ecx
 666:	eb d7                	jmp    63f <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 668:	74 19                	je     683 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 66a:	29 da                	sub    %ebx,%edx
 66c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 66f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 672:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 675:	89 0d 20 0c 00 00    	mov    %ecx,0xc20
      return (void*)(p + 1);
 67b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 67e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 681:	c9                   	leave  
 682:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 683:	8b 10                	mov    (%eax),%edx
 685:	89 11                	mov    %edx,(%ecx)
 687:	eb ec                	jmp    675 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 689:	89 c1                	mov    %eax,%ecx
 68b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	39 da                	cmp    %ebx,%edx
 692:	73 d4                	jae    668 <malloc+0x46>
    if(p == freep)
 694:	39 05 20 0c 00 00    	cmp    %eax,0xc20
 69a:	75 ed                	jne    689 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 69c:	89 d8                	mov    %ebx,%eax
 69e:	e8 2f ff ff ff       	call   5d2 <morecore>
 6a3:	85 c0                	test   %eax,%eax
 6a5:	75 e2                	jne    689 <malloc+0x67>
 6a7:	eb d5                	jmp    67e <malloc+0x5c>
