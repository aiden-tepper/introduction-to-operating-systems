
_test_13:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
#include "pstat.h"

int
main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 50 04 00 00    	sub    $0x450,%esp
  struct pstat pstat;

  int pid1, pid2;
  int fd1, fd2;

  fd1 = open(p1_file, O_CREATE | O_WRONLY);
  17:	68 01 02 00 00       	push   $0x201
  1c:	68 6c 07 00 00       	push   $0x76c
  21:	e8 73 03 00 00       	call   399 <open>
  if (fd1 < 0) {
  26:	83 c4 10             	add    $0x10,%esp
  29:	85 c0                	test   %eax,%eax
  2b:	78 6e                	js     9b <main+0x9b>
  2d:	89 c3                	mov    %eax,%ebx
    printf(2, "Open %s failed\n", p1_file);
    exit();
  }
 
  fd2 = open(p2_file, O_CREATE | O_WRONLY);
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	68 01 02 00 00       	push   $0x201
  37:	68 83 07 00 00       	push   $0x783
  3c:	e8 58 03 00 00       	call   399 <open>
  41:	89 c6                	mov    %eax,%esi
  if (fd2 < 0) {
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	78 6a                	js     b4 <main+0xb4>
    printf(2, "Open %s failed\n", p2_file);
    exit();
  }

  pid1 = fork();
  4a:	e8 02 03 00 00       	call   351 <fork>
  4f:	89 c7                	mov    %eax,%edi
  if (pid1 < 0) {
  51:	85 c0                	test   %eax,%eax
  53:	78 78                	js     cd <main+0xcd>
    printf(2, "Fork child process 1 failed\n");
  } else if (pid1 == 0) { // child process 1
  55:	0f 84 89 00 00 00    	je     e4 <main+0xe4>
    settickets(1);
    while(1)
      printf(fd1, "A");
  } 
  
  pid2 = fork();
  5b:	e8 f1 02 00 00       	call   351 <fork>
  60:	89 85 b4 fb ff ff    	mov    %eax,-0x44c(%ebp)
  if (pid2 < 0) {
  66:	85 c0                	test   %eax,%eax
  68:	0f 88 96 00 00 00    	js     104 <main+0x104>
    printf(2, "Fork child process 2 failed\n");
    exit();
  } else if (pid2 == 0) { // child process 2
  6e:	83 bd b4 fb ff ff 00 	cmpl   $0x0,-0x44c(%ebp)
  75:	0f 85 9d 00 00 00    	jne    118 <main+0x118>
    settickets(0);
  7b:	83 ec 0c             	sub    $0xc,%esp
  7e:	6a 00                	push   $0x0
  80:	e8 74 03 00 00       	call   3f9 <settickets>
  85:	83 c4 10             	add    $0x10,%esp
    while (1)  
      printf(fd2, "A");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 a7 07 00 00       	push   $0x7a7
  90:	56                   	push   %esi
  91:	e8 28 04 00 00       	call   4be <printf>
  96:	83 c4 10             	add    $0x10,%esp
  99:	eb ed                	jmp    88 <main+0x88>
    printf(2, "Open %s failed\n", p1_file);
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	68 6c 07 00 00       	push   $0x76c
  a3:	68 73 07 00 00       	push   $0x773
  a8:	6a 02                	push   $0x2
  aa:	e8 0f 04 00 00       	call   4be <printf>
    exit();
  af:	e8 a5 02 00 00       	call   359 <exit>
    printf(2, "Open %s failed\n", p2_file);
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	68 83 07 00 00       	push   $0x783
  bc:	68 73 07 00 00       	push   $0x773
  c1:	6a 02                	push   $0x2
  c3:	e8 f6 03 00 00       	call   4be <printf>
    exit();
  c8:	e8 8c 02 00 00       	call   359 <exit>
    printf(2, "Fork child process 1 failed\n");
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 8a 07 00 00       	push   $0x78a
  d5:	6a 02                	push   $0x2
  d7:	e8 e2 03 00 00       	call   4be <printf>
  dc:	83 c4 10             	add    $0x10,%esp
  df:	e9 77 ff ff ff       	jmp    5b <main+0x5b>
    settickets(1);
  e4:	83 ec 0c             	sub    $0xc,%esp
  e7:	6a 01                	push   $0x1
  e9:	e8 0b 03 00 00       	call   3f9 <settickets>
  ee:	83 c4 10             	add    $0x10,%esp
      printf(fd1, "A");
  f1:	83 ec 08             	sub    $0x8,%esp
  f4:	68 a7 07 00 00       	push   $0x7a7
  f9:	53                   	push   %ebx
  fa:	e8 bf 03 00 00       	call   4be <printf>
  ff:	83 c4 10             	add    $0x10,%esp
 102:	eb ed                	jmp    f1 <main+0xf1>
    printf(2, "Fork child process 2 failed\n");
 104:	83 ec 08             	sub    $0x8,%esp
 107:	68 a9 07 00 00       	push   $0x7a9
 10c:	6a 02                	push   $0x2
 10e:	e8 ab 03 00 00       	call   4be <printf>
    exit();
 113:	e8 41 02 00 00       	call   359 <exit>
  }

  sleep(1000);
 118:	83 ec 0c             	sub    $0xc,%esp
 11b:	68 e8 03 00 00       	push   $0x3e8
 120:	e8 c4 02 00 00       	call   3e9 <sleep>
  getpinfo(&pstat);
 125:	8d 85 c0 fb ff ff    	lea    -0x440(%ebp),%eax
 12b:	89 04 24             	mov    %eax,(%esp)
 12e:	e8 ce 02 00 00       	call   401 <getpinfo>
  kill(pid1);
 133:	89 3c 24             	mov    %edi,(%esp)
 136:	e8 4e 02 00 00       	call   389 <kill>
  kill(pid2);
 13b:	83 c4 04             	add    $0x4,%esp
 13e:	ff b5 b4 fb ff ff    	push   -0x44c(%ebp)
 144:	e8 40 02 00 00       	call   389 <kill>

  wait();
 149:	e8 13 02 00 00       	call   361 <wait>
  wait();
 14e:	e8 0e 02 00 00       	call   361 <wait>

  fstat(fd1, &f1);
 153:	83 c4 08             	add    $0x8,%esp
 156:	8d 45 d4             	lea    -0x2c(%ebp),%eax
 159:	50                   	push   %eax
 15a:	53                   	push   %ebx
 15b:	e8 51 02 00 00       	call   3b1 <fstat>
  fstat(fd2, &f2);
 160:	83 c4 08             	add    $0x8,%esp
 163:	8d 45 c0             	lea    -0x40(%ebp),%eax
 166:	50                   	push   %eax
 167:	56                   	push   %esi
 168:	e8 44 02 00 00       	call   3b1 <fstat>
  // compare file size made by child process
  if (f1.size > f2.size) {
 16d:	83 c4 10             	add    $0x10,%esp
 170:	8b 45 d0             	mov    -0x30(%ebp),%eax
 173:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 176:	77 2e                	ja     1a6 <main+0x1a6>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  }

  close(fd1);
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	53                   	push   %ebx
 17c:	e8 00 02 00 00       	call   381 <close>
  close(fd2);
 181:	89 34 24             	mov    %esi,(%esp)
 184:	e8 f8 01 00 00       	call   381 <close>
  
  unlink(p1_file);
 189:	c7 04 24 6c 07 00 00 	movl   $0x76c,(%esp)
 190:	e8 14 02 00 00       	call   3a9 <unlink>
  unlink(p2_file);
 195:	c7 04 24 83 07 00 00 	movl   $0x783,(%esp)
 19c:	e8 08 02 00 00       	call   3a9 <unlink>

  exit();
 1a1:	e8 b3 01 00 00       	call   359 <exit>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	68 c6 07 00 00       	push   $0x7c6
 1ae:	6a 01                	push   $0x1
 1b0:	e8 09 03 00 00       	call   4be <printf>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	eb be                	jmp    178 <main+0x178>

000001ba <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	56                   	push   %esi
 1be:	53                   	push   %ebx
 1bf:	8b 75 08             	mov    0x8(%ebp),%esi
 1c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c5:	89 f0                	mov    %esi,%eax
 1c7:	89 d1                	mov    %edx,%ecx
 1c9:	83 c2 01             	add    $0x1,%edx
 1cc:	89 c3                	mov    %eax,%ebx
 1ce:	83 c0 01             	add    $0x1,%eax
 1d1:	0f b6 09             	movzbl (%ecx),%ecx
 1d4:	88 0b                	mov    %cl,(%ebx)
 1d6:	84 c9                	test   %cl,%cl
 1d8:	75 ed                	jne    1c7 <strcpy+0xd>
    ;
  return os;
}
 1da:	89 f0                	mov    %esi,%eax
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1e9:	eb 06                	jmp    1f1 <strcmp+0x11>
    p++, q++;
 1eb:	83 c1 01             	add    $0x1,%ecx
 1ee:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1f1:	0f b6 01             	movzbl (%ecx),%eax
 1f4:	84 c0                	test   %al,%al
 1f6:	74 04                	je     1fc <strcmp+0x1c>
 1f8:	3a 02                	cmp    (%edx),%al
 1fa:	74 ef                	je     1eb <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1fc:	0f b6 c0             	movzbl %al,%eax
 1ff:	0f b6 12             	movzbl (%edx),%edx
 202:	29 d0                	sub    %edx,%eax
}
 204:	5d                   	pop    %ebp
 205:	c3                   	ret    

00000206 <strlen>:

uint
strlen(const char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 20c:	b8 00 00 00 00       	mov    $0x0,%eax
 211:	eb 03                	jmp    216 <strlen+0x10>
 213:	83 c0 01             	add    $0x1,%eax
 216:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 21a:	75 f7                	jne    213 <strlen+0xd>
    ;
  return n;
}
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    

0000021e <memset>:

void*
memset(void *dst, int c, uint n)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 225:	89 d7                	mov    %edx,%edi
 227:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	fc                   	cld    
 22e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 230:	89 d0                	mov    %edx,%eax
 232:	8b 7d fc             	mov    -0x4(%ebp),%edi
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <strchr>:

char*
strchr(const char *s, char c)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 241:	eb 03                	jmp    246 <strchr+0xf>
 243:	83 c0 01             	add    $0x1,%eax
 246:	0f b6 10             	movzbl (%eax),%edx
 249:	84 d2                	test   %dl,%dl
 24b:	74 06                	je     253 <strchr+0x1c>
    if(*s == c)
 24d:	38 ca                	cmp    %cl,%dl
 24f:	75 f2                	jne    243 <strchr+0xc>
 251:	eb 05                	jmp    258 <strchr+0x21>
      return (char*)s;
  return 0;
 253:	b8 00 00 00 00       	mov    $0x0,%eax
}
 258:	5d                   	pop    %ebp
 259:	c3                   	ret    

0000025a <gets>:

char*
gets(char *buf, int max)
{
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	57                   	push   %edi
 25e:	56                   	push   %esi
 25f:	53                   	push   %ebx
 260:	83 ec 1c             	sub    $0x1c,%esp
 263:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	bb 00 00 00 00       	mov    $0x0,%ebx
 26b:	89 de                	mov    %ebx,%esi
 26d:	83 c3 01             	add    $0x1,%ebx
 270:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 273:	7d 2e                	jge    2a3 <gets+0x49>
    cc = read(0, &c, 1);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	6a 01                	push   $0x1
 27a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	6a 00                	push   $0x0
 280:	e8 ec 00 00 00       	call   371 <read>
    if(cc < 1)
 285:	83 c4 10             	add    $0x10,%esp
 288:	85 c0                	test   %eax,%eax
 28a:	7e 17                	jle    2a3 <gets+0x49>
      break;
    buf[i++] = c;
 28c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 290:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 293:	3c 0a                	cmp    $0xa,%al
 295:	0f 94 c2             	sete   %dl
 298:	3c 0d                	cmp    $0xd,%al
 29a:	0f 94 c0             	sete   %al
 29d:	08 c2                	or     %al,%dl
 29f:	74 ca                	je     26b <gets+0x11>
    buf[i++] = c;
 2a1:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2a3:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2a7:	89 f8                	mov    %edi,%eax
 2a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ac:	5b                   	pop    %ebx
 2ad:	5e                   	pop    %esi
 2ae:	5f                   	pop    %edi
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    

000002b1 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b6:	83 ec 08             	sub    $0x8,%esp
 2b9:	6a 00                	push   $0x0
 2bb:	ff 75 08             	push   0x8(%ebp)
 2be:	e8 d6 00 00 00       	call   399 <open>
  if(fd < 0)
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	85 c0                	test   %eax,%eax
 2c8:	78 24                	js     2ee <stat+0x3d>
 2ca:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2cc:	83 ec 08             	sub    $0x8,%esp
 2cf:	ff 75 0c             	push   0xc(%ebp)
 2d2:	50                   	push   %eax
 2d3:	e8 d9 00 00 00       	call   3b1 <fstat>
 2d8:	89 c6                	mov    %eax,%esi
  close(fd);
 2da:	89 1c 24             	mov    %ebx,(%esp)
 2dd:	e8 9f 00 00 00       	call   381 <close>
  return r;
 2e2:	83 c4 10             	add    $0x10,%esp
}
 2e5:	89 f0                	mov    %esi,%eax
 2e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2ea:	5b                   	pop    %ebx
 2eb:	5e                   	pop    %esi
 2ec:	5d                   	pop    %ebp
 2ed:	c3                   	ret    
    return -1;
 2ee:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2f3:	eb f0                	jmp    2e5 <stat+0x34>

000002f5 <atoi>:

int
atoi(const char *s)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	53                   	push   %ebx
 2f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2fc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 301:	eb 10                	jmp    313 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 303:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 306:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 309:	83 c1 01             	add    $0x1,%ecx
 30c:	0f be c0             	movsbl %al,%eax
 30f:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 313:	0f b6 01             	movzbl (%ecx),%eax
 316:	8d 58 d0             	lea    -0x30(%eax),%ebx
 319:	80 fb 09             	cmp    $0x9,%bl
 31c:	76 e5                	jbe    303 <atoi+0xe>
  return n;
}
 31e:	89 d0                	mov    %edx,%eax
 320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	56                   	push   %esi
 329:	53                   	push   %ebx
 32a:	8b 75 08             	mov    0x8(%ebp),%esi
 32d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 330:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 333:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 335:	eb 0d                	jmp    344 <memmove+0x1f>
    *dst++ = *src++;
 337:	0f b6 01             	movzbl (%ecx),%eax
 33a:	88 02                	mov    %al,(%edx)
 33c:	8d 49 01             	lea    0x1(%ecx),%ecx
 33f:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 342:	89 d8                	mov    %ebx,%eax
 344:	8d 58 ff             	lea    -0x1(%eax),%ebx
 347:	85 c0                	test   %eax,%eax
 349:	7f ec                	jg     337 <memmove+0x12>
  return vdst;
}
 34b:	89 f0                	mov    %esi,%eax
 34d:	5b                   	pop    %ebx
 34e:	5e                   	pop    %esi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    

00000351 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 351:	b8 01 00 00 00       	mov    $0x1,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <exit>:
SYSCALL(exit)
 359:	b8 02 00 00 00       	mov    $0x2,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <wait>:
SYSCALL(wait)
 361:	b8 03 00 00 00       	mov    $0x3,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <pipe>:
SYSCALL(pipe)
 369:	b8 04 00 00 00       	mov    $0x4,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <read>:
SYSCALL(read)
 371:	b8 05 00 00 00       	mov    $0x5,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <write>:
SYSCALL(write)
 379:	b8 10 00 00 00       	mov    $0x10,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <close>:
SYSCALL(close)
 381:	b8 15 00 00 00       	mov    $0x15,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <kill>:
SYSCALL(kill)
 389:	b8 06 00 00 00       	mov    $0x6,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <exec>:
SYSCALL(exec)
 391:	b8 07 00 00 00       	mov    $0x7,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <open>:
SYSCALL(open)
 399:	b8 0f 00 00 00       	mov    $0xf,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <mknod>:
SYSCALL(mknod)
 3a1:	b8 11 00 00 00       	mov    $0x11,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <unlink>:
SYSCALL(unlink)
 3a9:	b8 12 00 00 00       	mov    $0x12,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <fstat>:
SYSCALL(fstat)
 3b1:	b8 08 00 00 00       	mov    $0x8,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <link>:
SYSCALL(link)
 3b9:	b8 13 00 00 00       	mov    $0x13,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <mkdir>:
SYSCALL(mkdir)
 3c1:	b8 14 00 00 00       	mov    $0x14,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <chdir>:
SYSCALL(chdir)
 3c9:	b8 09 00 00 00       	mov    $0x9,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <dup>:
SYSCALL(dup)
 3d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <getpid>:
SYSCALL(getpid)
 3d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <sbrk>:
SYSCALL(sbrk)
 3e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <sleep>:
SYSCALL(sleep)
 3e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <uptime>:
SYSCALL(uptime)
 3f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <settickets>:
SYSCALL(settickets)
 3f9:	b8 16 00 00 00       	mov    $0x16,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <getpinfo>:
SYSCALL(getpinfo)
 401:	b8 17 00 00 00       	mov    $0x17,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <mprotect>:
SYSCALL(mprotect)
 409:	b8 18 00 00 00       	mov    $0x18,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <munprotect>:
SYSCALL(munprotect)
 411:	b8 19 00 00 00       	mov    $0x19,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 419:	55                   	push   %ebp
 41a:	89 e5                	mov    %esp,%ebp
 41c:	83 ec 1c             	sub    $0x1c,%esp
 41f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 422:	6a 01                	push   $0x1
 424:	8d 55 f4             	lea    -0xc(%ebp),%edx
 427:	52                   	push   %edx
 428:	50                   	push   %eax
 429:	e8 4b ff ff ff       	call   379 <write>
}
 42e:	83 c4 10             	add    $0x10,%esp
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	57                   	push   %edi
 437:	56                   	push   %esi
 438:	53                   	push   %ebx
 439:	83 ec 2c             	sub    $0x2c,%esp
 43c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 43f:	89 d0                	mov    %edx,%eax
 441:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 447:	0f 95 c1             	setne  %cl
 44a:	c1 ea 1f             	shr    $0x1f,%edx
 44d:	84 d1                	test   %dl,%cl
 44f:	74 44                	je     495 <printint+0x62>
    neg = 1;
    x = -xx;
 451:	f7 d8                	neg    %eax
 453:	89 c1                	mov    %eax,%ecx
    neg = 1;
 455:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 45c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 461:	89 c8                	mov    %ecx,%eax
 463:	ba 00 00 00 00       	mov    $0x0,%edx
 468:	f7 f6                	div    %esi
 46a:	89 df                	mov    %ebx,%edi
 46c:	83 c3 01             	add    $0x1,%ebx
 46f:	0f b6 92 40 08 00 00 	movzbl 0x840(%edx),%edx
 476:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 47a:	89 ca                	mov    %ecx,%edx
 47c:	89 c1                	mov    %eax,%ecx
 47e:	39 d6                	cmp    %edx,%esi
 480:	76 df                	jbe    461 <printint+0x2e>
  if(neg)
 482:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 486:	74 31                	je     4b9 <printint+0x86>
    buf[i++] = '-';
 488:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 48d:	8d 5f 02             	lea    0x2(%edi),%ebx
 490:	8b 75 d0             	mov    -0x30(%ebp),%esi
 493:	eb 17                	jmp    4ac <printint+0x79>
    x = xx;
 495:	89 c1                	mov    %eax,%ecx
  neg = 0;
 497:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 49e:	eb bc                	jmp    45c <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 4a0:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4a5:	89 f0                	mov    %esi,%eax
 4a7:	e8 6d ff ff ff       	call   419 <putc>
  while(--i >= 0)
 4ac:	83 eb 01             	sub    $0x1,%ebx
 4af:	79 ef                	jns    4a0 <printint+0x6d>
}
 4b1:	83 c4 2c             	add    $0x2c,%esp
 4b4:	5b                   	pop    %ebx
 4b5:	5e                   	pop    %esi
 4b6:	5f                   	pop    %edi
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    
 4b9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4bc:	eb ee                	jmp    4ac <printint+0x79>

000004be <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	57                   	push   %edi
 4c2:	56                   	push   %esi
 4c3:	53                   	push   %ebx
 4c4:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4c7:	8d 45 10             	lea    0x10(%ebp),%eax
 4ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4cd:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4d2:	bb 00 00 00 00       	mov    $0x0,%ebx
 4d7:	eb 14                	jmp    4ed <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4d9:	89 fa                	mov    %edi,%edx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 36 ff ff ff       	call   419 <putc>
 4e3:	eb 05                	jmp    4ea <printf+0x2c>
      }
    } else if(state == '%'){
 4e5:	83 fe 25             	cmp    $0x25,%esi
 4e8:	74 25                	je     50f <printf+0x51>
  for(i = 0; fmt[i]; i++){
 4ea:	83 c3 01             	add    $0x1,%ebx
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4f4:	84 c0                	test   %al,%al
 4f6:	0f 84 20 01 00 00    	je     61c <printf+0x15e>
    c = fmt[i] & 0xff;
 4fc:	0f be f8             	movsbl %al,%edi
 4ff:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 502:	85 f6                	test   %esi,%esi
 504:	75 df                	jne    4e5 <printf+0x27>
      if(c == '%'){
 506:	83 f8 25             	cmp    $0x25,%eax
 509:	75 ce                	jne    4d9 <printf+0x1b>
        state = '%';
 50b:	89 c6                	mov    %eax,%esi
 50d:	eb db                	jmp    4ea <printf+0x2c>
      if(c == 'd'){
 50f:	83 f8 25             	cmp    $0x25,%eax
 512:	0f 84 cf 00 00 00    	je     5e7 <printf+0x129>
 518:	0f 8c dd 00 00 00    	jl     5fb <printf+0x13d>
 51e:	83 f8 78             	cmp    $0x78,%eax
 521:	0f 8f d4 00 00 00    	jg     5fb <printf+0x13d>
 527:	83 f8 63             	cmp    $0x63,%eax
 52a:	0f 8c cb 00 00 00    	jl     5fb <printf+0x13d>
 530:	83 e8 63             	sub    $0x63,%eax
 533:	83 f8 15             	cmp    $0x15,%eax
 536:	0f 87 bf 00 00 00    	ja     5fb <printf+0x13d>
 53c:	ff 24 85 e8 07 00 00 	jmp    *0x7e8(,%eax,4)
        printint(fd, *ap, 10, 1);
 543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 546:	8b 17                	mov    (%edi),%edx
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	6a 01                	push   $0x1
 54d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	e8 d9 fe ff ff       	call   433 <printint>
        ap++;
 55a:	83 c7 04             	add    $0x4,%edi
 55d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 560:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 563:	be 00 00 00 00       	mov    $0x0,%esi
 568:	eb 80                	jmp    4ea <printf+0x2c>
        printint(fd, *ap, 16, 0);
 56a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 56d:	8b 17                	mov    (%edi),%edx
 56f:	83 ec 0c             	sub    $0xc,%esp
 572:	6a 00                	push   $0x0
 574:	b9 10 00 00 00       	mov    $0x10,%ecx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	e8 b2 fe ff ff       	call   433 <printint>
        ap++;
 581:	83 c7 04             	add    $0x4,%edi
 584:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 587:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58a:	be 00 00 00 00       	mov    $0x0,%esi
 58f:	e9 56 ff ff ff       	jmp    4ea <printf+0x2c>
        s = (char*)*ap;
 594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 597:	8b 30                	mov    (%eax),%esi
        ap++;
 599:	83 c0 04             	add    $0x4,%eax
 59c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 59f:	85 f6                	test   %esi,%esi
 5a1:	75 15                	jne    5b8 <printf+0xfa>
          s = "(null)";
 5a3:	be de 07 00 00       	mov    $0x7de,%esi
 5a8:	eb 0e                	jmp    5b8 <printf+0xfa>
          putc(fd, *s);
 5aa:	0f be d2             	movsbl %dl,%edx
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	e8 64 fe ff ff       	call   419 <putc>
          s++;
 5b5:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5b8:	0f b6 16             	movzbl (%esi),%edx
 5bb:	84 d2                	test   %dl,%dl
 5bd:	75 eb                	jne    5aa <printf+0xec>
      state = 0;
 5bf:	be 00 00 00 00       	mov    $0x0,%esi
 5c4:	e9 21 ff ff ff       	jmp    4ea <printf+0x2c>
        putc(fd, *ap);
 5c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cc:	0f be 17             	movsbl (%edi),%edx
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	e8 42 fe ff ff       	call   419 <putc>
        ap++;
 5d7:	83 c7 04             	add    $0x4,%edi
 5da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5dd:	be 00 00 00 00       	mov    $0x0,%esi
 5e2:	e9 03 ff ff ff       	jmp    4ea <printf+0x2c>
        putc(fd, c);
 5e7:	89 fa                	mov    %edi,%edx
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	e8 28 fe ff ff       	call   419 <putc>
      state = 0;
 5f1:	be 00 00 00 00       	mov    $0x0,%esi
 5f6:	e9 ef fe ff ff       	jmp    4ea <printf+0x2c>
        putc(fd, '%');
 5fb:	ba 25 00 00 00       	mov    $0x25,%edx
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	e8 11 fe ff ff       	call   419 <putc>
        putc(fd, c);
 608:	89 fa                	mov    %edi,%edx
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	e8 07 fe ff ff       	call   419 <putc>
      state = 0;
 612:	be 00 00 00 00       	mov    $0x0,%esi
 617:	e9 ce fe ff ff       	jmp    4ea <printf+0x2c>
    }
  }
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    

00000624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	57                   	push   %edi
 628:	56                   	push   %esi
 629:	53                   	push   %ebx
 62a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	a1 ec 0a 00 00       	mov    0xaec,%eax
 635:	eb 02                	jmp    639 <free+0x15>
 637:	89 d0                	mov    %edx,%eax
 639:	39 c8                	cmp    %ecx,%eax
 63b:	73 04                	jae    641 <free+0x1d>
 63d:	39 08                	cmp    %ecx,(%eax)
 63f:	77 12                	ja     653 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 641:	8b 10                	mov    (%eax),%edx
 643:	39 c2                	cmp    %eax,%edx
 645:	77 f0                	ja     637 <free+0x13>
 647:	39 c8                	cmp    %ecx,%eax
 649:	72 08                	jb     653 <free+0x2f>
 64b:	39 ca                	cmp    %ecx,%edx
 64d:	77 04                	ja     653 <free+0x2f>
 64f:	89 d0                	mov    %edx,%eax
 651:	eb e6                	jmp    639 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 73 fc             	mov    -0x4(%ebx),%esi
 656:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 659:	8b 10                	mov    (%eax),%edx
 65b:	39 d7                	cmp    %edx,%edi
 65d:	74 19                	je     678 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 65f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 662:	8b 50 04             	mov    0x4(%eax),%edx
 665:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 668:	39 ce                	cmp    %ecx,%esi
 66a:	74 1b                	je     687 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 66c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 66e:	a3 ec 0a 00 00       	mov    %eax,0xaec
}
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 678:	03 72 04             	add    0x4(%edx),%esi
 67b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 67e:	8b 10                	mov    (%eax),%edx
 680:	8b 12                	mov    (%edx),%edx
 682:	89 53 f8             	mov    %edx,-0x8(%ebx)
 685:	eb db                	jmp    662 <free+0x3e>
    p->s.size += bp->s.size;
 687:	03 53 fc             	add    -0x4(%ebx),%edx
 68a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 690:	89 10                	mov    %edx,(%eax)
 692:	eb da                	jmp    66e <free+0x4a>

00000694 <morecore>:

static Header*
morecore(uint nu)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	53                   	push   %ebx
 698:	83 ec 04             	sub    $0x4,%esp
 69b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 69d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6a2:	77 05                	ja     6a9 <morecore+0x15>
    nu = 4096;
 6a4:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6a9:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	50                   	push   %eax
 6b4:	e8 28 fd ff ff       	call   3e1 <sbrk>
  if(p == (char*)-1)
 6b9:	83 c4 10             	add    $0x10,%esp
 6bc:	83 f8 ff             	cmp    $0xffffffff,%eax
 6bf:	74 1c                	je     6dd <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6c1:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6c4:	83 c0 08             	add    $0x8,%eax
 6c7:	83 ec 0c             	sub    $0xc,%esp
 6ca:	50                   	push   %eax
 6cb:	e8 54 ff ff ff       	call   624 <free>
  return freep;
 6d0:	a1 ec 0a 00 00       	mov    0xaec,%eax
 6d5:	83 c4 10             	add    $0x10,%esp
}
 6d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6db:	c9                   	leave  
 6dc:	c3                   	ret    
    return 0;
 6dd:	b8 00 00 00 00       	mov    $0x0,%eax
 6e2:	eb f4                	jmp    6d8 <morecore+0x44>

000006e4 <malloc>:

void*
malloc(uint nbytes)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	53                   	push   %ebx
 6e8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	8d 58 07             	lea    0x7(%eax),%ebx
 6f1:	c1 eb 03             	shr    $0x3,%ebx
 6f4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6f7:	8b 0d ec 0a 00 00    	mov    0xaec,%ecx
 6fd:	85 c9                	test   %ecx,%ecx
 6ff:	74 04                	je     705 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 701:	8b 01                	mov    (%ecx),%eax
 703:	eb 4a                	jmp    74f <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 705:	c7 05 ec 0a 00 00 f0 	movl   $0xaf0,0xaec
 70c:	0a 00 00 
 70f:	c7 05 f0 0a 00 00 f0 	movl   $0xaf0,0xaf0
 716:	0a 00 00 
    base.s.size = 0;
 719:	c7 05 f4 0a 00 00 00 	movl   $0x0,0xaf4
 720:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 723:	b9 f0 0a 00 00       	mov    $0xaf0,%ecx
 728:	eb d7                	jmp    701 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 72a:	74 19                	je     745 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 72c:	29 da                	sub    %ebx,%edx
 72e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 731:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 734:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 737:	89 0d ec 0a 00 00    	mov    %ecx,0xaec
      return (void*)(p + 1);
 73d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 743:	c9                   	leave  
 744:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 745:	8b 10                	mov    (%eax),%edx
 747:	89 11                	mov    %edx,(%ecx)
 749:	eb ec                	jmp    737 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74b:	89 c1                	mov    %eax,%ecx
 74d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 74f:	8b 50 04             	mov    0x4(%eax),%edx
 752:	39 da                	cmp    %ebx,%edx
 754:	73 d4                	jae    72a <malloc+0x46>
    if(p == freep)
 756:	39 05 ec 0a 00 00    	cmp    %eax,0xaec
 75c:	75 ed                	jne    74b <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 75e:	89 d8                	mov    %ebx,%eax
 760:	e8 2f ff ff ff       	call   694 <morecore>
 765:	85 c0                	test   %eax,%eax
 767:	75 e2                	jne    74b <malloc+0x67>
 769:	eb d5                	jmp    740 <malloc+0x5c>
