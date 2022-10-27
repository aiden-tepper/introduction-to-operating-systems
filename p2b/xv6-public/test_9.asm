
_test_9:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 08 04 00 00    	sub    $0x408,%esp
	int pid_par = getpid();
  17:	e8 01 03 00 00       	call   31d <getpid>
  1c:	89 c3                	mov    %eax,%ebx
	int tickets = 0;
	
	if(settickets(tickets) == 0)
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	6a 00                	push   $0x0
  23:	e8 15 03 00 00       	call   33d <settickets>
  28:	83 c4 10             	add    $0x10,%esp
  2b:	85 c0                	test   %eax,%eax
  2d:	74 14                	je     43 <main+0x43>
	{
	}
	else
	{
	 printf(1, "XV6_SCHEDULER\t FAILED\n");
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	68 b0 06 00 00       	push   $0x6b0
  37:	6a 01                	push   $0x1
  39:	e8 c4 03 00 00       	call   402 <printf>
	 exit();
  3e:	e8 5a 02 00 00       	call   29d <exit>
	}
	
	if(fork() == 0){
  43:	e8 4d 02 00 00       	call   295 <fork>
  48:	85 c0                	test   %eax,%eax
  4a:	74 0e                	je     5a <main+0x5a>
		 printf(1, "XV6_SCHEDULER\t FAILED\n");
		}

    exit();
	}
  	while(wait() > 0);
  4c:	e8 54 02 00 00       	call   2a5 <wait>
  51:	85 c0                	test   %eax,%eax
  53:	7f f7                	jg     4c <main+0x4c>
	exit();
  55:	e8 43 02 00 00       	call   29d <exit>
		int pid_chd = getpid();
  5a:	e8 be 02 00 00       	call   31d <getpid>
  5f:	89 c6                	mov    %eax,%esi
		if(getpinfo(&st) == 0)
  61:	83 ec 0c             	sub    $0xc,%esp
  64:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
  6a:	50                   	push   %eax
  6b:	e8 d5 02 00 00       	call   345 <getpinfo>
  70:	83 c4 10             	add    $0x10,%esp
  73:	85 c0                	test   %eax,%eax
  75:	75 0c                	jne    83 <main+0x83>
		int tickets_par = -1,tickets_chd = -1;
  77:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  7c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  81:	eb 1e                	jmp    a1 <main+0xa1>
		 printf(1, "XV6_SCHEDULER\t FAILED\n");
  83:	83 ec 08             	sub    $0x8,%esp
  86:	68 b0 06 00 00       	push   $0x6b0
  8b:	6a 01                	push   $0x1
  8d:	e8 70 03 00 00       	call   402 <printf>
		 exit();
  92:	e8 06 02 00 00       	call   29d <exit>
				tickets_par = st.tickets[i];
  97:	8b 8c 85 e8 fc ff ff 	mov    -0x318(%ebp,%eax,4),%ecx
		for(int i = 0; i < NPROC; i++){
  9e:	83 c0 01             	add    $0x1,%eax
  a1:	83 f8 3f             	cmp    $0x3f,%eax
  a4:	7f 18                	jg     be <main+0xbe>
      			if (st.pid[i] == pid_par){
  a6:	8b 94 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%edx
  ad:	39 da                	cmp    %ebx,%edx
  af:	74 e6                	je     97 <main+0x97>
			else if (st.pid[i] == pid_chd){
  b1:	39 f2                	cmp    %esi,%edx
  b3:	75 e9                	jne    9e <main+0x9e>
				tickets_chd = st.tickets[i];
  b5:	8b bc 85 e8 fc ff ff 	mov    -0x318(%ebp,%eax,4),%edi
  bc:	eb e0                	jmp    9e <main+0x9e>
		printf(1, "parent: %d, child: %d\n", tickets_par, tickets_chd);
  be:	57                   	push   %edi
  bf:	51                   	push   %ecx
  c0:	68 c7 06 00 00       	push   $0x6c7
  c5:	6a 01                	push   $0x1
  c7:	e8 36 03 00 00       	call   402 <printf>
		if(tickets_chd == tickets)
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	85 ff                	test   %edi,%edi
  d1:	75 17                	jne    ea <main+0xea>
		 printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  d3:	83 ec 08             	sub    $0x8,%esp
  d6:	68 de 06 00 00       	push   $0x6de
  db:	6a 01                	push   $0x1
  dd:	e8 20 03 00 00       	call   402 <printf>
  e2:	83 c4 10             	add    $0x10,%esp
    exit();
  e5:	e8 b3 01 00 00       	call   29d <exit>
		 printf(1, "XV6_SCHEDULER\t FAILED\n");
  ea:	83 ec 08             	sub    $0x8,%esp
  ed:	68 b0 06 00 00       	push   $0x6b0
  f2:	6a 01                	push   $0x1
  f4:	e8 09 03 00 00       	call   402 <printf>
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	eb e7                	jmp    e5 <main+0xe5>

000000fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	56                   	push   %esi
 102:	53                   	push   %ebx
 103:	8b 75 08             	mov    0x8(%ebp),%esi
 106:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 109:	89 f0                	mov    %esi,%eax
 10b:	89 d1                	mov    %edx,%ecx
 10d:	83 c2 01             	add    $0x1,%edx
 110:	89 c3                	mov    %eax,%ebx
 112:	83 c0 01             	add    $0x1,%eax
 115:	0f b6 09             	movzbl (%ecx),%ecx
 118:	88 0b                	mov    %cl,(%ebx)
 11a:	84 c9                	test   %cl,%cl
 11c:	75 ed                	jne    10b <strcpy+0xd>
    ;
  return os;
}
 11e:	89 f0                	mov    %esi,%eax
 120:	5b                   	pop    %ebx
 121:	5e                   	pop    %esi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 12d:	eb 06                	jmp    135 <strcmp+0x11>
    p++, q++;
 12f:	83 c1 01             	add    $0x1,%ecx
 132:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 135:	0f b6 01             	movzbl (%ecx),%eax
 138:	84 c0                	test   %al,%al
 13a:	74 04                	je     140 <strcmp+0x1c>
 13c:	3a 02                	cmp    (%edx),%al
 13e:	74 ef                	je     12f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 140:	0f b6 c0             	movzbl %al,%eax
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	29 d0                	sub    %edx,%eax
}
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 150:	b8 00 00 00 00       	mov    $0x0,%eax
 155:	eb 03                	jmp    15a <strlen+0x10>
 157:	83 c0 01             	add    $0x1,%eax
 15a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 15e:	75 f7                	jne    157 <strlen+0xd>
    ;
  return n;
}
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    

00000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	57                   	push   %edi
 166:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 169:	89 d7                	mov    %edx,%edi
 16b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	fc                   	cld    
 172:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 174:	89 d0                	mov    %edx,%eax
 176:	8b 7d fc             	mov    -0x4(%ebp),%edi
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <strchr>:

char*
strchr(const char *s, char c)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 185:	eb 03                	jmp    18a <strchr+0xf>
 187:	83 c0 01             	add    $0x1,%eax
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	74 06                	je     197 <strchr+0x1c>
    if(*s == c)
 191:	38 ca                	cmp    %cl,%dl
 193:	75 f2                	jne    187 <strchr+0xc>
 195:	eb 05                	jmp    19c <strchr+0x21>
      return (char*)s;
  return 0;
 197:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    

0000019e <gets>:

char*
gets(char *buf, int max)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	57                   	push   %edi
 1a2:	56                   	push   %esi
 1a3:	53                   	push   %ebx
 1a4:	83 ec 1c             	sub    $0x1c,%esp
 1a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1aa:	bb 00 00 00 00       	mov    $0x0,%ebx
 1af:	89 de                	mov    %ebx,%esi
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b7:	7d 2e                	jge    1e7 <gets+0x49>
    cc = read(0, &c, 1);
 1b9:	83 ec 04             	sub    $0x4,%esp
 1bc:	6a 01                	push   $0x1
 1be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1c1:	50                   	push   %eax
 1c2:	6a 00                	push   $0x0
 1c4:	e8 ec 00 00 00       	call   2b5 <read>
    if(cc < 1)
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	85 c0                	test   %eax,%eax
 1ce:	7e 17                	jle    1e7 <gets+0x49>
      break;
    buf[i++] = c;
 1d0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d4:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1d7:	3c 0a                	cmp    $0xa,%al
 1d9:	0f 94 c2             	sete   %dl
 1dc:	3c 0d                	cmp    $0xd,%al
 1de:	0f 94 c0             	sete   %al
 1e1:	08 c2                	or     %al,%dl
 1e3:	74 ca                	je     1af <gets+0x11>
    buf[i++] = c;
 1e5:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1e7:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1eb:	89 f8                	mov    %edi,%eax
 1ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	56                   	push   %esi
 1f9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	83 ec 08             	sub    $0x8,%esp
 1fd:	6a 00                	push   $0x0
 1ff:	ff 75 08             	push   0x8(%ebp)
 202:	e8 d6 00 00 00       	call   2dd <open>
  if(fd < 0)
 207:	83 c4 10             	add    $0x10,%esp
 20a:	85 c0                	test   %eax,%eax
 20c:	78 24                	js     232 <stat+0x3d>
 20e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	50                   	push   %eax
 217:	e8 d9 00 00 00       	call   2f5 <fstat>
 21c:	89 c6                	mov    %eax,%esi
  close(fd);
 21e:	89 1c 24             	mov    %ebx,(%esp)
 221:	e8 9f 00 00 00       	call   2c5 <close>
  return r;
 226:	83 c4 10             	add    $0x10,%esp
}
 229:	89 f0                	mov    %esi,%eax
 22b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22e:	5b                   	pop    %ebx
 22f:	5e                   	pop    %esi
 230:	5d                   	pop    %ebp
 231:	c3                   	ret    
    return -1;
 232:	be ff ff ff ff       	mov    $0xffffffff,%esi
 237:	eb f0                	jmp    229 <stat+0x34>

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	53                   	push   %ebx
 23d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 240:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 245:	eb 10                	jmp    257 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 247:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 24a:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 24d:	83 c1 01             	add    $0x1,%ecx
 250:	0f be c0             	movsbl %al,%eax
 253:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 257:	0f b6 01             	movzbl (%ecx),%eax
 25a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 25d:	80 fb 09             	cmp    $0x9,%bl
 260:	76 e5                	jbe    247 <atoi+0xe>
  return n;
}
 262:	89 d0                	mov    %edx,%eax
 264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	56                   	push   %esi
 26d:	53                   	push   %ebx
 26e:	8b 75 08             	mov    0x8(%ebp),%esi
 271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 274:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 277:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 279:	eb 0d                	jmp    288 <memmove+0x1f>
    *dst++ = *src++;
 27b:	0f b6 01             	movzbl (%ecx),%eax
 27e:	88 02                	mov    %al,(%edx)
 280:	8d 49 01             	lea    0x1(%ecx),%ecx
 283:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 286:	89 d8                	mov    %ebx,%eax
 288:	8d 58 ff             	lea    -0x1(%eax),%ebx
 28b:	85 c0                	test   %eax,%eax
 28d:	7f ec                	jg     27b <memmove+0x12>
  return vdst;
}
 28f:	89 f0                	mov    %esi,%eax
 291:	5b                   	pop    %ebx
 292:	5e                   	pop    %esi
 293:	5d                   	pop    %ebp
 294:	c3                   	ret    

00000295 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 295:	b8 01 00 00 00       	mov    $0x1,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <exit>:
SYSCALL(exit)
 29d:	b8 02 00 00 00       	mov    $0x2,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <wait>:
SYSCALL(wait)
 2a5:	b8 03 00 00 00       	mov    $0x3,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <pipe>:
SYSCALL(pipe)
 2ad:	b8 04 00 00 00       	mov    $0x4,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <read>:
SYSCALL(read)
 2b5:	b8 05 00 00 00       	mov    $0x5,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <write>:
SYSCALL(write)
 2bd:	b8 10 00 00 00       	mov    $0x10,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <close>:
SYSCALL(close)
 2c5:	b8 15 00 00 00       	mov    $0x15,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <kill>:
SYSCALL(kill)
 2cd:	b8 06 00 00 00       	mov    $0x6,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <exec>:
SYSCALL(exec)
 2d5:	b8 07 00 00 00       	mov    $0x7,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <open>:
SYSCALL(open)
 2dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <mknod>:
SYSCALL(mknod)
 2e5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <unlink>:
SYSCALL(unlink)
 2ed:	b8 12 00 00 00       	mov    $0x12,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <fstat>:
SYSCALL(fstat)
 2f5:	b8 08 00 00 00       	mov    $0x8,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <link>:
SYSCALL(link)
 2fd:	b8 13 00 00 00       	mov    $0x13,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <mkdir>:
SYSCALL(mkdir)
 305:	b8 14 00 00 00       	mov    $0x14,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <chdir>:
SYSCALL(chdir)
 30d:	b8 09 00 00 00       	mov    $0x9,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <dup>:
SYSCALL(dup)
 315:	b8 0a 00 00 00       	mov    $0xa,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <getpid>:
SYSCALL(getpid)
 31d:	b8 0b 00 00 00       	mov    $0xb,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <sbrk>:
SYSCALL(sbrk)
 325:	b8 0c 00 00 00       	mov    $0xc,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <sleep>:
SYSCALL(sleep)
 32d:	b8 0d 00 00 00       	mov    $0xd,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <uptime>:
SYSCALL(uptime)
 335:	b8 0e 00 00 00       	mov    $0xe,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <settickets>:
SYSCALL(settickets)
 33d:	b8 16 00 00 00       	mov    $0x16,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <getpinfo>:
SYSCALL(getpinfo)
 345:	b8 17 00 00 00       	mov    $0x17,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mprotect>:
SYSCALL(mprotect)
 34d:	b8 18 00 00 00       	mov    $0x18,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <munprotect>:
SYSCALL(munprotect)
 355:	b8 19 00 00 00       	mov    $0x19,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 1c             	sub    $0x1c,%esp
 363:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 366:	6a 01                	push   $0x1
 368:	8d 55 f4             	lea    -0xc(%ebp),%edx
 36b:	52                   	push   %edx
 36c:	50                   	push   %eax
 36d:	e8 4b ff ff ff       	call   2bd <write>
}
 372:	83 c4 10             	add    $0x10,%esp
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	57                   	push   %edi
 37b:	56                   	push   %esi
 37c:	53                   	push   %ebx
 37d:	83 ec 2c             	sub    $0x2c,%esp
 380:	89 45 d0             	mov    %eax,-0x30(%ebp)
 383:	89 d0                	mov    %edx,%eax
 385:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 38b:	0f 95 c1             	setne  %cl
 38e:	c1 ea 1f             	shr    $0x1f,%edx
 391:	84 d1                	test   %dl,%cl
 393:	74 44                	je     3d9 <printint+0x62>
    neg = 1;
    x = -xx;
 395:	f7 d8                	neg    %eax
 397:	89 c1                	mov    %eax,%ecx
    neg = 1;
 399:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3a5:	89 c8                	mov    %ecx,%eax
 3a7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ac:	f7 f6                	div    %esi
 3ae:	89 df                	mov    %ebx,%edi
 3b0:	83 c3 01             	add    $0x1,%ebx
 3b3:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 3ba:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3be:	89 ca                	mov    %ecx,%edx
 3c0:	89 c1                	mov    %eax,%ecx
 3c2:	39 d6                	cmp    %edx,%esi
 3c4:	76 df                	jbe    3a5 <printint+0x2e>
  if(neg)
 3c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3ca:	74 31                	je     3fd <printint+0x86>
    buf[i++] = '-';
 3cc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3d1:	8d 5f 02             	lea    0x2(%edi),%ebx
 3d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3d7:	eb 17                	jmp    3f0 <printint+0x79>
    x = xx;
 3d9:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3db:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3e2:	eb bc                	jmp    3a0 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3e4:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e9:	89 f0                	mov    %esi,%eax
 3eb:	e8 6d ff ff ff       	call   35d <putc>
  while(--i >= 0)
 3f0:	83 eb 01             	sub    $0x1,%ebx
 3f3:	79 ef                	jns    3e4 <printint+0x6d>
}
 3f5:	83 c4 2c             	add    $0x2c,%esp
 3f8:	5b                   	pop    %ebx
 3f9:	5e                   	pop    %esi
 3fa:	5f                   	pop    %edi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
 400:	eb ee                	jmp    3f0 <printint+0x79>

00000402 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	57                   	push   %edi
 406:	56                   	push   %esi
 407:	53                   	push   %ebx
 408:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 40b:	8d 45 10             	lea    0x10(%ebp),%eax
 40e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 411:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 416:	bb 00 00 00 00       	mov    $0x0,%ebx
 41b:	eb 14                	jmp    431 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 41d:	89 fa                	mov    %edi,%edx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	e8 36 ff ff ff       	call   35d <putc>
 427:	eb 05                	jmp    42e <printf+0x2c>
      }
    } else if(state == '%'){
 429:	83 fe 25             	cmp    $0x25,%esi
 42c:	74 25                	je     453 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 42e:	83 c3 01             	add    $0x1,%ebx
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 438:	84 c0                	test   %al,%al
 43a:	0f 84 20 01 00 00    	je     560 <printf+0x15e>
    c = fmt[i] & 0xff;
 440:	0f be f8             	movsbl %al,%edi
 443:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 446:	85 f6                	test   %esi,%esi
 448:	75 df                	jne    429 <printf+0x27>
      if(c == '%'){
 44a:	83 f8 25             	cmp    $0x25,%eax
 44d:	75 ce                	jne    41d <printf+0x1b>
        state = '%';
 44f:	89 c6                	mov    %eax,%esi
 451:	eb db                	jmp    42e <printf+0x2c>
      if(c == 'd'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	0f 84 cf 00 00 00    	je     52b <printf+0x129>
 45c:	0f 8c dd 00 00 00    	jl     53f <printf+0x13d>
 462:	83 f8 78             	cmp    $0x78,%eax
 465:	0f 8f d4 00 00 00    	jg     53f <printf+0x13d>
 46b:	83 f8 63             	cmp    $0x63,%eax
 46e:	0f 8c cb 00 00 00    	jl     53f <printf+0x13d>
 474:	83 e8 63             	sub    $0x63,%eax
 477:	83 f8 15             	cmp    $0x15,%eax
 47a:	0f 87 bf 00 00 00    	ja     53f <printf+0x13d>
 480:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
        printint(fd, *ap, 10, 1);
 487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48a:	8b 17                	mov    (%edi),%edx
 48c:	83 ec 0c             	sub    $0xc,%esp
 48f:	6a 01                	push   $0x1
 491:	b9 0a 00 00 00       	mov    $0xa,%ecx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	e8 d9 fe ff ff       	call   377 <printint>
        ap++;
 49e:	83 c7 04             	add    $0x4,%edi
 4a1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4a4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a7:	be 00 00 00 00       	mov    $0x0,%esi
 4ac:	eb 80                	jmp    42e <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b1:	8b 17                	mov    (%edi),%edx
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	6a 00                	push   $0x0
 4b8:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 b2 fe ff ff       	call   377 <printint>
        ap++;
 4c5:	83 c7 04             	add    $0x4,%edi
 4c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4cb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ce:	be 00 00 00 00       	mov    $0x0,%esi
 4d3:	e9 56 ff ff ff       	jmp    42e <printf+0x2c>
        s = (char*)*ap;
 4d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4db:	8b 30                	mov    (%eax),%esi
        ap++;
 4dd:	83 c0 04             	add    $0x4,%eax
 4e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4e3:	85 f6                	test   %esi,%esi
 4e5:	75 15                	jne    4fc <printf+0xfa>
          s = "(null)";
 4e7:	be f6 06 00 00       	mov    $0x6f6,%esi
 4ec:	eb 0e                	jmp    4fc <printf+0xfa>
          putc(fd, *s);
 4ee:	0f be d2             	movsbl %dl,%edx
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	e8 64 fe ff ff       	call   35d <putc>
          s++;
 4f9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4fc:	0f b6 16             	movzbl (%esi),%edx
 4ff:	84 d2                	test   %dl,%dl
 501:	75 eb                	jne    4ee <printf+0xec>
      state = 0;
 503:	be 00 00 00 00       	mov    $0x0,%esi
 508:	e9 21 ff ff ff       	jmp    42e <printf+0x2c>
        putc(fd, *ap);
 50d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 510:	0f be 17             	movsbl (%edi),%edx
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	e8 42 fe ff ff       	call   35d <putc>
        ap++;
 51b:	83 c7 04             	add    $0x4,%edi
 51e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 521:	be 00 00 00 00       	mov    $0x0,%esi
 526:	e9 03 ff ff ff       	jmp    42e <printf+0x2c>
        putc(fd, c);
 52b:	89 fa                	mov    %edi,%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 28 fe ff ff       	call   35d <putc>
      state = 0;
 535:	be 00 00 00 00       	mov    $0x0,%esi
 53a:	e9 ef fe ff ff       	jmp    42e <printf+0x2c>
        putc(fd, '%');
 53f:	ba 25 00 00 00       	mov    $0x25,%edx
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	e8 11 fe ff ff       	call   35d <putc>
        putc(fd, c);
 54c:	89 fa                	mov    %edi,%edx
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	e8 07 fe ff ff       	call   35d <putc>
      state = 0;
 556:	be 00 00 00 00       	mov    $0x0,%esi
 55b:	e9 ce fe ff ff       	jmp    42e <printf+0x2c>
    }
  }
}
 560:	8d 65 f4             	lea    -0xc(%ebp),%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    

00000568 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	57                   	push   %edi
 56c:	56                   	push   %esi
 56d:	53                   	push   %ebx
 56e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 571:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 574:	a1 04 0a 00 00       	mov    0xa04,%eax
 579:	eb 02                	jmp    57d <free+0x15>
 57b:	89 d0                	mov    %edx,%eax
 57d:	39 c8                	cmp    %ecx,%eax
 57f:	73 04                	jae    585 <free+0x1d>
 581:	39 08                	cmp    %ecx,(%eax)
 583:	77 12                	ja     597 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 585:	8b 10                	mov    (%eax),%edx
 587:	39 c2                	cmp    %eax,%edx
 589:	77 f0                	ja     57b <free+0x13>
 58b:	39 c8                	cmp    %ecx,%eax
 58d:	72 08                	jb     597 <free+0x2f>
 58f:	39 ca                	cmp    %ecx,%edx
 591:	77 04                	ja     597 <free+0x2f>
 593:	89 d0                	mov    %edx,%eax
 595:	eb e6                	jmp    57d <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 597:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59d:	8b 10                	mov    (%eax),%edx
 59f:	39 d7                	cmp    %edx,%edi
 5a1:	74 19                	je     5bc <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5a3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a6:	8b 50 04             	mov    0x4(%eax),%edx
 5a9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5ac:	39 ce                	cmp    %ecx,%esi
 5ae:	74 1b                	je     5cb <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b0:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5b2:	a3 04 0a 00 00       	mov    %eax,0xa04
}
 5b7:	5b                   	pop    %ebx
 5b8:	5e                   	pop    %esi
 5b9:	5f                   	pop    %edi
 5ba:	5d                   	pop    %ebp
 5bb:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5bc:	03 72 04             	add    0x4(%edx),%esi
 5bf:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5c2:	8b 10                	mov    (%eax),%edx
 5c4:	8b 12                	mov    (%edx),%edx
 5c6:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c9:	eb db                	jmp    5a6 <free+0x3e>
    p->s.size += bp->s.size;
 5cb:	03 53 fc             	add    -0x4(%ebx),%edx
 5ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d4:	89 10                	mov    %edx,(%eax)
 5d6:	eb da                	jmp    5b2 <free+0x4a>

000005d8 <morecore>:

static Header*
morecore(uint nu)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	53                   	push   %ebx
 5dc:	83 ec 04             	sub    $0x4,%esp
 5df:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5e1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5e6:	77 05                	ja     5ed <morecore+0x15>
    nu = 4096;
 5e8:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5ed:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5f4:	83 ec 0c             	sub    $0xc,%esp
 5f7:	50                   	push   %eax
 5f8:	e8 28 fd ff ff       	call   325 <sbrk>
  if(p == (char*)-1)
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	83 f8 ff             	cmp    $0xffffffff,%eax
 603:	74 1c                	je     621 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 605:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 608:	83 c0 08             	add    $0x8,%eax
 60b:	83 ec 0c             	sub    $0xc,%esp
 60e:	50                   	push   %eax
 60f:	e8 54 ff ff ff       	call   568 <free>
  return freep;
 614:	a1 04 0a 00 00       	mov    0xa04,%eax
 619:	83 c4 10             	add    $0x10,%esp
}
 61c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 61f:	c9                   	leave  
 620:	c3                   	ret    
    return 0;
 621:	b8 00 00 00 00       	mov    $0x0,%eax
 626:	eb f4                	jmp    61c <morecore+0x44>

00000628 <malloc>:

void*
malloc(uint nbytes)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	53                   	push   %ebx
 62c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	8d 58 07             	lea    0x7(%eax),%ebx
 635:	c1 eb 03             	shr    $0x3,%ebx
 638:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 63b:	8b 0d 04 0a 00 00    	mov    0xa04,%ecx
 641:	85 c9                	test   %ecx,%ecx
 643:	74 04                	je     649 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 645:	8b 01                	mov    (%ecx),%eax
 647:	eb 4a                	jmp    693 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 649:	c7 05 04 0a 00 00 08 	movl   $0xa08,0xa04
 650:	0a 00 00 
 653:	c7 05 08 0a 00 00 08 	movl   $0xa08,0xa08
 65a:	0a 00 00 
    base.s.size = 0;
 65d:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 664:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 667:	b9 08 0a 00 00       	mov    $0xa08,%ecx
 66c:	eb d7                	jmp    645 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 66e:	74 19                	je     689 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 670:	29 da                	sub    %ebx,%edx
 672:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 675:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 678:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 67b:	89 0d 04 0a 00 00    	mov    %ecx,0xa04
      return (void*)(p + 1);
 681:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 687:	c9                   	leave  
 688:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 689:	8b 10                	mov    (%eax),%edx
 68b:	89 11                	mov    %edx,(%ecx)
 68d:	eb ec                	jmp    67b <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68f:	89 c1                	mov    %eax,%ecx
 691:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 693:	8b 50 04             	mov    0x4(%eax),%edx
 696:	39 da                	cmp    %ebx,%edx
 698:	73 d4                	jae    66e <malloc+0x46>
    if(p == freep)
 69a:	39 05 04 0a 00 00    	cmp    %eax,0xa04
 6a0:	75 ed                	jne    68f <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6a2:	89 d8                	mov    %ebx,%eax
 6a4:	e8 2f ff ff ff       	call   5d8 <morecore>
 6a9:	85 c0                	test   %eax,%eax
 6ab:	75 e2                	jne    68f <malloc+0x67>
 6ad:	eb d5                	jmp    684 <malloc+0x5c>
