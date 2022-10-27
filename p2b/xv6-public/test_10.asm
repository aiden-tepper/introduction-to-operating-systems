
_test_10:     file format elf32-i386


Disassembly of section .text:

00000000 <spin>:
void spin()
{
	int i = 0;
  int j = 0;
  int k = 0;
	for(i = 0; i < 50; ++i)
   0:	ba 00 00 00 00       	mov    $0x0,%edx
   5:	eb 0d                	jmp    14 <spin+0x14>
	{
		for(j = 0; j < 10000000; ++j)
   7:	83 c0 01             	add    $0x1,%eax
   a:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
   f:	7e f6                	jle    7 <spin+0x7>
	for(i = 0; i < 50; ++i)
  11:	83 c2 01             	add    $0x1,%edx
  14:	83 fa 31             	cmp    $0x31,%edx
  17:	7f 07                	jg     20 <spin+0x20>
		for(j = 0; j < 10000000; ++j)
  19:	b8 00 00 00 00       	mov    $0x0,%eax
  1e:	eb ea                	jmp    a <spin+0xa>
		{
      k = j % 10;
      k = k + 1;
    }
	}
}
  20:	c3                   	ret    

00000021 <main>:


int
main(int argc, char *argv[])
{
  21:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  25:	83 e4 f0             	and    $0xfffffff0,%esp
  28:	ff 71 fc             	push   -0x4(%ecx)
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	57                   	push   %edi
  2f:	56                   	push   %esi
  30:	53                   	push   %ebx
  31:	51                   	push   %ecx
  32:	81 ec 10 05 00 00    	sub    $0x510,%esp
   struct pstat st;
   int count = 0;
   int i = 0;
   int pid[NPROC];
   printf(1,"Spinning...\n");
  38:	68 10 07 00 00       	push   $0x710
  3d:	6a 01                	push   $0x1
  3f:	e8 1f 04 00 00       	call   463 <printf>
   while(i < PROC)
  44:	83 c4 10             	add    $0x10,%esp
   int i = 0;
  47:	bb 00 00 00 00       	mov    $0x0,%ebx
   while(i < PROC)
  4c:	83 fb 04             	cmp    $0x4,%ebx
  4f:	7f 1a                	jg     6b <main+0x4a>
   {
      pid[i] = fork();
  51:	e8 a0 02 00 00       	call   2f6 <fork>
  56:	89 84 9d e8 fa ff ff 	mov    %eax,-0x518(%ebp,%ebx,4)
	    if(pid[i] == 0)
  5d:	85 c0                	test   %eax,%eax
  5f:	74 05                	je     66 <main+0x45>
     {
		    spin();
		    exit();
      }
	  i++;
  61:	83 c3 01             	add    $0x1,%ebx
  64:	eb e6                	jmp    4c <main+0x2b>
		    exit();
  66:	e8 93 02 00 00       	call   2fe <exit>
   }
   sleep(500);
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	68 f4 01 00 00       	push   $0x1f4
  73:	e8 16 03 00 00       	call   38e <sleep>
   //spin();
   if(getpinfo(&st) == 0)
  78:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
  7e:	89 04 24             	mov    %eax,(%esp)
  81:	e8 20 03 00 00       	call   3a6 <getpinfo>
  86:	89 c7                	mov    %eax,%edi
  88:	83 c4 10             	add    $0x10,%esp
  8b:	85 c0                	test   %eax,%eax
  8d:	74 14                	je     a3 <main+0x82>
   {
   }
   else
   {
    printf(1, "XV6_SCHEDULER\t FAILED\n");
  8f:	83 ec 08             	sub    $0x8,%esp
  92:	68 1d 07 00 00       	push   $0x71d
  97:	6a 01                	push   $0x1
  99:	e8 c5 03 00 00       	call   463 <printf>
    exit();
  9e:	e8 5b 02 00 00       	call   2fe <exit>
   }

   printf(1, "\n**** PInfo ****\n");
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	68 34 07 00 00       	push   $0x734
  ab:	6a 01                	push   $0x1
  ad:	e8 b1 03 00 00       	call   463 <printf>
   for(i = 0; i < NPROC; i++) {
  b2:	83 c4 10             	add    $0x10,%esp
  b5:	89 fb                	mov    %edi,%ebx
   int count = 0;
  b7:	89 fe                	mov    %edi,%esi
   for(i = 0; i < NPROC; i++) {
  b9:	eb 03                	jmp    be <main+0x9d>
  bb:	83 c3 01             	add    $0x1,%ebx
  be:	83 fb 3f             	cmp    $0x3f,%ebx
  c1:	7f 4b                	jg     10e <main+0xed>
      if (st.inuse[i]) {
  c3:	83 bc 9d e8 fb ff ff 	cmpl   $0x0,-0x418(%ebp,%ebx,4)
  ca:	00 
  cb:	74 ee                	je     bb <main+0x9a>
	       count++;
  cd:	83 c6 01             	add    $0x1,%esi
         printf(1, "pid: %d tickets: %d ticks: %d\n", st.pid[i], st.tickets[i], st.ticks[i]);
  d0:	83 ec 0c             	sub    $0xc,%esp
  d3:	ff b4 9d e8 fe ff ff 	push   -0x118(%ebp,%ebx,4)
  da:	ff b4 9d e8 fc ff ff 	push   -0x318(%ebp,%ebx,4)
  e1:	ff b4 9d e8 fd ff ff 	push   -0x218(%ebp,%ebx,4)
  e8:	68 60 07 00 00       	push   $0x760
  ed:	6a 01                	push   $0x1
  ef:	e8 6f 03 00 00       	call   463 <printf>
  f4:	83 c4 20             	add    $0x20,%esp
  f7:	eb c2                	jmp    bb <main+0x9a>
      }
   }
   for(i = 0; i < PROC; i++)
   {
	    kill(pid[i]);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff b4 bd e8 fa ff ff 	push   -0x518(%ebp,%edi,4)
 103:	e8 26 02 00 00       	call   32e <kill>
   for(i = 0; i < PROC; i++)
 108:	83 c7 01             	add    $0x1,%edi
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	83 ff 04             	cmp    $0x4,%edi
 111:	7e e6                	jle    f9 <main+0xd8>
   }
   while (wait() > 0);
 113:	e8 ee 01 00 00       	call   306 <wait>
 118:	85 c0                	test   %eax,%eax
 11a:	7f f7                	jg     113 <main+0xf2>
   printf(1,"Number of processes in use %d\n", count);
 11c:	83 ec 04             	sub    $0x4,%esp
 11f:	56                   	push   %esi
 120:	68 80 07 00 00       	push   $0x780
 125:	6a 01                	push   $0x1
 127:	e8 37 03 00 00       	call   463 <printf>
   
   if(count == 8)
 12c:	83 c4 10             	add    $0x10,%esp
 12f:	83 fe 08             	cmp    $0x8,%esi
 132:	74 17                	je     14b <main+0x12a>
   {
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
   }
   else
   {
    printf(1, "XV6_SCHEDULER\t FAILED\n");
 134:	83 ec 08             	sub    $0x8,%esp
 137:	68 1d 07 00 00       	push   $0x71d
 13c:	6a 01                	push   $0x1
 13e:	e8 20 03 00 00       	call   463 <printf>
 143:	83 c4 10             	add    $0x10,%esp
   }
    
   exit();
 146:	e8 b3 01 00 00       	call   2fe <exit>
    printf(1, "XV6_SCHEDULER\t SUCCESS\n");
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	68 46 07 00 00       	push   $0x746
 153:	6a 01                	push   $0x1
 155:	e8 09 03 00 00       	call   463 <printf>
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	eb e7                	jmp    146 <main+0x125>

0000015f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	56                   	push   %esi
 163:	53                   	push   %ebx
 164:	8b 75 08             	mov    0x8(%ebp),%esi
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	89 f0                	mov    %esi,%eax
 16c:	89 d1                	mov    %edx,%ecx
 16e:	83 c2 01             	add    $0x1,%edx
 171:	89 c3                	mov    %eax,%ebx
 173:	83 c0 01             	add    $0x1,%eax
 176:	0f b6 09             	movzbl (%ecx),%ecx
 179:	88 0b                	mov    %cl,(%ebx)
 17b:	84 c9                	test   %cl,%cl
 17d:	75 ed                	jne    16c <strcpy+0xd>
    ;
  return os;
}
 17f:	89 f0                	mov    %esi,%eax
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 18e:	eb 06                	jmp    196 <strcmp+0x11>
    p++, q++;
 190:	83 c1 01             	add    $0x1,%ecx
 193:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 196:	0f b6 01             	movzbl (%ecx),%eax
 199:	84 c0                	test   %al,%al
 19b:	74 04                	je     1a1 <strcmp+0x1c>
 19d:	3a 02                	cmp    (%edx),%al
 19f:	74 ef                	je     190 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1a1:	0f b6 c0             	movzbl %al,%eax
 1a4:	0f b6 12             	movzbl (%edx),%edx
 1a7:	29 d0                	sub    %edx,%eax
}
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strlen>:

uint
strlen(const char *s)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
 1b6:	eb 03                	jmp    1bb <strlen+0x10>
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1bf:	75 f7                	jne    1b8 <strlen+0xd>
    ;
  return n;
}
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    

000001c3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	57                   	push   %edi
 1c7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1ca:	89 d7                	mov    %edx,%edi
 1cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	fc                   	cld    
 1d3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1e6:	eb 03                	jmp    1eb <strchr+0xf>
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	0f b6 10             	movzbl (%eax),%edx
 1ee:	84 d2                	test   %dl,%dl
 1f0:	74 06                	je     1f8 <strchr+0x1c>
    if(*s == c)
 1f2:	38 ca                	cmp    %cl,%dl
 1f4:	75 f2                	jne    1e8 <strchr+0xc>
 1f6:	eb 05                	jmp    1fd <strchr+0x21>
      return (char*)s;
  return 0;
 1f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fd:	5d                   	pop    %ebp
 1fe:	c3                   	ret    

000001ff <gets>:

char*
gets(char *buf, int max)
{
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
 202:	57                   	push   %edi
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
 205:	83 ec 1c             	sub    $0x1c,%esp
 208:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20b:	bb 00 00 00 00       	mov    $0x0,%ebx
 210:	89 de                	mov    %ebx,%esi
 212:	83 c3 01             	add    $0x1,%ebx
 215:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 218:	7d 2e                	jge    248 <gets+0x49>
    cc = read(0, &c, 1);
 21a:	83 ec 04             	sub    $0x4,%esp
 21d:	6a 01                	push   $0x1
 21f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 222:	50                   	push   %eax
 223:	6a 00                	push   $0x0
 225:	e8 ec 00 00 00       	call   316 <read>
    if(cc < 1)
 22a:	83 c4 10             	add    $0x10,%esp
 22d:	85 c0                	test   %eax,%eax
 22f:	7e 17                	jle    248 <gets+0x49>
      break;
    buf[i++] = c;
 231:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 235:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 238:	3c 0a                	cmp    $0xa,%al
 23a:	0f 94 c2             	sete   %dl
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	0f 94 c0             	sete   %al
 242:	08 c2                	or     %al,%dl
 244:	74 ca                	je     210 <gets+0x11>
    buf[i++] = c;
 246:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 248:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 24c:	89 f8                	mov    %edi,%eax
 24e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 251:	5b                   	pop    %ebx
 252:	5e                   	pop    %esi
 253:	5f                   	pop    %edi
 254:	5d                   	pop    %ebp
 255:	c3                   	ret    

00000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	56                   	push   %esi
 25a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25b:	83 ec 08             	sub    $0x8,%esp
 25e:	6a 00                	push   $0x0
 260:	ff 75 08             	push   0x8(%ebp)
 263:	e8 d6 00 00 00       	call   33e <open>
  if(fd < 0)
 268:	83 c4 10             	add    $0x10,%esp
 26b:	85 c0                	test   %eax,%eax
 26d:	78 24                	js     293 <stat+0x3d>
 26f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 271:	83 ec 08             	sub    $0x8,%esp
 274:	ff 75 0c             	push   0xc(%ebp)
 277:	50                   	push   %eax
 278:	e8 d9 00 00 00       	call   356 <fstat>
 27d:	89 c6                	mov    %eax,%esi
  close(fd);
 27f:	89 1c 24             	mov    %ebx,(%esp)
 282:	e8 9f 00 00 00       	call   326 <close>
  return r;
 287:	83 c4 10             	add    $0x10,%esp
}
 28a:	89 f0                	mov    %esi,%eax
 28c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28f:	5b                   	pop    %ebx
 290:	5e                   	pop    %esi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
    return -1;
 293:	be ff ff ff ff       	mov    $0xffffffff,%esi
 298:	eb f0                	jmp    28a <stat+0x34>

0000029a <atoi>:

int
atoi(const char *s)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	53                   	push   %ebx
 29e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2a1:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2a6:	eb 10                	jmp    2b8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 2a8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2ab:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2ae:	83 c1 01             	add    $0x1,%ecx
 2b1:	0f be c0             	movsbl %al,%eax
 2b4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 2b8:	0f b6 01             	movzbl (%ecx),%eax
 2bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2be:	80 fb 09             	cmp    $0x9,%bl
 2c1:	76 e5                	jbe    2a8 <atoi+0xe>
  return n;
}
 2c3:	89 d0                	mov    %edx,%eax
 2c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	56                   	push   %esi
 2ce:	53                   	push   %ebx
 2cf:	8b 75 08             	mov    0x8(%ebp),%esi
 2d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2d5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2d8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2da:	eb 0d                	jmp    2e9 <memmove+0x1f>
    *dst++ = *src++;
 2dc:	0f b6 01             	movzbl (%ecx),%eax
 2df:	88 02                	mov    %al,(%edx)
 2e1:	8d 49 01             	lea    0x1(%ecx),%ecx
 2e4:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2e7:	89 d8                	mov    %ebx,%eax
 2e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2ec:	85 c0                	test   %eax,%eax
 2ee:	7f ec                	jg     2dc <memmove+0x12>
  return vdst;
}
 2f0:	89 f0                	mov    %esi,%eax
 2f2:	5b                   	pop    %ebx
 2f3:	5e                   	pop    %esi
 2f4:	5d                   	pop    %ebp
 2f5:	c3                   	ret    

000002f6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f6:	b8 01 00 00 00       	mov    $0x1,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <exit>:
SYSCALL(exit)
 2fe:	b8 02 00 00 00       	mov    $0x2,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <wait>:
SYSCALL(wait)
 306:	b8 03 00 00 00       	mov    $0x3,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <pipe>:
SYSCALL(pipe)
 30e:	b8 04 00 00 00       	mov    $0x4,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <read>:
SYSCALL(read)
 316:	b8 05 00 00 00       	mov    $0x5,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <write>:
SYSCALL(write)
 31e:	b8 10 00 00 00       	mov    $0x10,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <close>:
SYSCALL(close)
 326:	b8 15 00 00 00       	mov    $0x15,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <kill>:
SYSCALL(kill)
 32e:	b8 06 00 00 00       	mov    $0x6,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <exec>:
SYSCALL(exec)
 336:	b8 07 00 00 00       	mov    $0x7,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <open>:
SYSCALL(open)
 33e:	b8 0f 00 00 00       	mov    $0xf,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <mknod>:
SYSCALL(mknod)
 346:	b8 11 00 00 00       	mov    $0x11,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <unlink>:
SYSCALL(unlink)
 34e:	b8 12 00 00 00       	mov    $0x12,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <fstat>:
SYSCALL(fstat)
 356:	b8 08 00 00 00       	mov    $0x8,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <link>:
SYSCALL(link)
 35e:	b8 13 00 00 00       	mov    $0x13,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <mkdir>:
SYSCALL(mkdir)
 366:	b8 14 00 00 00       	mov    $0x14,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <chdir>:
SYSCALL(chdir)
 36e:	b8 09 00 00 00       	mov    $0x9,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <dup>:
SYSCALL(dup)
 376:	b8 0a 00 00 00       	mov    $0xa,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <getpid>:
SYSCALL(getpid)
 37e:	b8 0b 00 00 00       	mov    $0xb,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <sbrk>:
SYSCALL(sbrk)
 386:	b8 0c 00 00 00       	mov    $0xc,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <sleep>:
SYSCALL(sleep)
 38e:	b8 0d 00 00 00       	mov    $0xd,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <uptime>:
SYSCALL(uptime)
 396:	b8 0e 00 00 00       	mov    $0xe,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <settickets>:
SYSCALL(settickets)
 39e:	b8 16 00 00 00       	mov    $0x16,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <getpinfo>:
SYSCALL(getpinfo)
 3a6:	b8 17 00 00 00       	mov    $0x17,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mprotect>:
SYSCALL(mprotect)
 3ae:	b8 18 00 00 00       	mov    $0x18,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <munprotect>:
SYSCALL(munprotect)
 3b6:	b8 19 00 00 00       	mov    $0x19,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3be:	55                   	push   %ebp
 3bf:	89 e5                	mov    %esp,%ebp
 3c1:	83 ec 1c             	sub    $0x1c,%esp
 3c4:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3c7:	6a 01                	push   $0x1
 3c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3cc:	52                   	push   %edx
 3cd:	50                   	push   %eax
 3ce:	e8 4b ff ff ff       	call   31e <write>
}
 3d3:	83 c4 10             	add    $0x10,%esp
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	57                   	push   %edi
 3dc:	56                   	push   %esi
 3dd:	53                   	push   %ebx
 3de:	83 ec 2c             	sub    $0x2c,%esp
 3e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3e4:	89 d0                	mov    %edx,%eax
 3e6:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ec:	0f 95 c1             	setne  %cl
 3ef:	c1 ea 1f             	shr    $0x1f,%edx
 3f2:	84 d1                	test   %dl,%cl
 3f4:	74 44                	je     43a <printint+0x62>
    neg = 1;
    x = -xx;
 3f6:	f7 d8                	neg    %eax
 3f8:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3fa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 401:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 406:	89 c8                	mov    %ecx,%eax
 408:	ba 00 00 00 00       	mov    $0x0,%edx
 40d:	f7 f6                	div    %esi
 40f:	89 df                	mov    %ebx,%edi
 411:	83 c3 01             	add    $0x1,%ebx
 414:	0f b6 92 00 08 00 00 	movzbl 0x800(%edx),%edx
 41b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 41f:	89 ca                	mov    %ecx,%edx
 421:	89 c1                	mov    %eax,%ecx
 423:	39 d6                	cmp    %edx,%esi
 425:	76 df                	jbe    406 <printint+0x2e>
  if(neg)
 427:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 42b:	74 31                	je     45e <printint+0x86>
    buf[i++] = '-';
 42d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 432:	8d 5f 02             	lea    0x2(%edi),%ebx
 435:	8b 75 d0             	mov    -0x30(%ebp),%esi
 438:	eb 17                	jmp    451 <printint+0x79>
    x = xx;
 43a:	89 c1                	mov    %eax,%ecx
  neg = 0;
 43c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 443:	eb bc                	jmp    401 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 445:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 44a:	89 f0                	mov    %esi,%eax
 44c:	e8 6d ff ff ff       	call   3be <putc>
  while(--i >= 0)
 451:	83 eb 01             	sub    $0x1,%ebx
 454:	79 ef                	jns    445 <printint+0x6d>
}
 456:	83 c4 2c             	add    $0x2c,%esp
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5f                   	pop    %edi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    
 45e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 461:	eb ee                	jmp    451 <printint+0x79>

00000463 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	57                   	push   %edi
 467:	56                   	push   %esi
 468:	53                   	push   %ebx
 469:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 46c:	8d 45 10             	lea    0x10(%ebp),%eax
 46f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 472:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 477:	bb 00 00 00 00       	mov    $0x0,%ebx
 47c:	eb 14                	jmp    492 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 47e:	89 fa                	mov    %edi,%edx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	e8 36 ff ff ff       	call   3be <putc>
 488:	eb 05                	jmp    48f <printf+0x2c>
      }
    } else if(state == '%'){
 48a:	83 fe 25             	cmp    $0x25,%esi
 48d:	74 25                	je     4b4 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 48f:	83 c3 01             	add    $0x1,%ebx
 492:	8b 45 0c             	mov    0xc(%ebp),%eax
 495:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 499:	84 c0                	test   %al,%al
 49b:	0f 84 20 01 00 00    	je     5c1 <printf+0x15e>
    c = fmt[i] & 0xff;
 4a1:	0f be f8             	movsbl %al,%edi
 4a4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4a7:	85 f6                	test   %esi,%esi
 4a9:	75 df                	jne    48a <printf+0x27>
      if(c == '%'){
 4ab:	83 f8 25             	cmp    $0x25,%eax
 4ae:	75 ce                	jne    47e <printf+0x1b>
        state = '%';
 4b0:	89 c6                	mov    %eax,%esi
 4b2:	eb db                	jmp    48f <printf+0x2c>
      if(c == 'd'){
 4b4:	83 f8 25             	cmp    $0x25,%eax
 4b7:	0f 84 cf 00 00 00    	je     58c <printf+0x129>
 4bd:	0f 8c dd 00 00 00    	jl     5a0 <printf+0x13d>
 4c3:	83 f8 78             	cmp    $0x78,%eax
 4c6:	0f 8f d4 00 00 00    	jg     5a0 <printf+0x13d>
 4cc:	83 f8 63             	cmp    $0x63,%eax
 4cf:	0f 8c cb 00 00 00    	jl     5a0 <printf+0x13d>
 4d5:	83 e8 63             	sub    $0x63,%eax
 4d8:	83 f8 15             	cmp    $0x15,%eax
 4db:	0f 87 bf 00 00 00    	ja     5a0 <printf+0x13d>
 4e1:	ff 24 85 a8 07 00 00 	jmp    *0x7a8(,%eax,4)
        printint(fd, *ap, 10, 1);
 4e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4eb:	8b 17                	mov    (%edi),%edx
 4ed:	83 ec 0c             	sub    $0xc,%esp
 4f0:	6a 01                	push   $0x1
 4f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	e8 d9 fe ff ff       	call   3d8 <printint>
        ap++;
 4ff:	83 c7 04             	add    $0x4,%edi
 502:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 505:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 508:	be 00 00 00 00       	mov    $0x0,%esi
 50d:	eb 80                	jmp    48f <printf+0x2c>
        printint(fd, *ap, 16, 0);
 50f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 512:	8b 17                	mov    (%edi),%edx
 514:	83 ec 0c             	sub    $0xc,%esp
 517:	6a 00                	push   $0x0
 519:	b9 10 00 00 00       	mov    $0x10,%ecx
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	e8 b2 fe ff ff       	call   3d8 <printint>
        ap++;
 526:	83 c7 04             	add    $0x4,%edi
 529:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 52c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52f:	be 00 00 00 00       	mov    $0x0,%esi
 534:	e9 56 ff ff ff       	jmp    48f <printf+0x2c>
        s = (char*)*ap;
 539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53c:	8b 30                	mov    (%eax),%esi
        ap++;
 53e:	83 c0 04             	add    $0x4,%eax
 541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 544:	85 f6                	test   %esi,%esi
 546:	75 15                	jne    55d <printf+0xfa>
          s = "(null)";
 548:	be 9f 07 00 00       	mov    $0x79f,%esi
 54d:	eb 0e                	jmp    55d <printf+0xfa>
          putc(fd, *s);
 54f:	0f be d2             	movsbl %dl,%edx
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	e8 64 fe ff ff       	call   3be <putc>
          s++;
 55a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 55d:	0f b6 16             	movzbl (%esi),%edx
 560:	84 d2                	test   %dl,%dl
 562:	75 eb                	jne    54f <printf+0xec>
      state = 0;
 564:	be 00 00 00 00       	mov    $0x0,%esi
 569:	e9 21 ff ff ff       	jmp    48f <printf+0x2c>
        putc(fd, *ap);
 56e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 571:	0f be 17             	movsbl (%edi),%edx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 42 fe ff ff       	call   3be <putc>
        ap++;
 57c:	83 c7 04             	add    $0x4,%edi
 57f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 582:	be 00 00 00 00       	mov    $0x0,%esi
 587:	e9 03 ff ff ff       	jmp    48f <printf+0x2c>
        putc(fd, c);
 58c:	89 fa                	mov    %edi,%edx
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	e8 28 fe ff ff       	call   3be <putc>
      state = 0;
 596:	be 00 00 00 00       	mov    $0x0,%esi
 59b:	e9 ef fe ff ff       	jmp    48f <printf+0x2c>
        putc(fd, '%');
 5a0:	ba 25 00 00 00       	mov    $0x25,%edx
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	e8 11 fe ff ff       	call   3be <putc>
        putc(fd, c);
 5ad:	89 fa                	mov    %edi,%edx
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	e8 07 fe ff ff       	call   3be <putc>
      state = 0;
 5b7:	be 00 00 00 00       	mov    $0x0,%esi
 5bc:	e9 ce fe ff ff       	jmp    48f <printf+0x2c>
    }
  }
}
 5c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c4:	5b                   	pop    %ebx
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    

000005c9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c9:	55                   	push   %ebp
 5ca:	89 e5                	mov    %esp,%ebp
 5cc:	57                   	push   %edi
 5cd:	56                   	push   %esi
 5ce:	53                   	push   %ebx
 5cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d5:	a1 c0 0a 00 00       	mov    0xac0,%eax
 5da:	eb 02                	jmp    5de <free+0x15>
 5dc:	89 d0                	mov    %edx,%eax
 5de:	39 c8                	cmp    %ecx,%eax
 5e0:	73 04                	jae    5e6 <free+0x1d>
 5e2:	39 08                	cmp    %ecx,(%eax)
 5e4:	77 12                	ja     5f8 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	39 c2                	cmp    %eax,%edx
 5ea:	77 f0                	ja     5dc <free+0x13>
 5ec:	39 c8                	cmp    %ecx,%eax
 5ee:	72 08                	jb     5f8 <free+0x2f>
 5f0:	39 ca                	cmp    %ecx,%edx
 5f2:	77 04                	ja     5f8 <free+0x2f>
 5f4:	89 d0                	mov    %edx,%eax
 5f6:	eb e6                	jmp    5de <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fe:	8b 10                	mov    (%eax),%edx
 600:	39 d7                	cmp    %edx,%edi
 602:	74 19                	je     61d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 604:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 607:	8b 50 04             	mov    0x4(%eax),%edx
 60a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60d:	39 ce                	cmp    %ecx,%esi
 60f:	74 1b                	je     62c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 611:	89 08                	mov    %ecx,(%eax)
  freep = p;
 613:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 618:	5b                   	pop    %ebx
 619:	5e                   	pop    %esi
 61a:	5f                   	pop    %edi
 61b:	5d                   	pop    %ebp
 61c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 61d:	03 72 04             	add    0x4(%edx),%esi
 620:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 623:	8b 10                	mov    (%eax),%edx
 625:	8b 12                	mov    (%edx),%edx
 627:	89 53 f8             	mov    %edx,-0x8(%ebx)
 62a:	eb db                	jmp    607 <free+0x3e>
    p->s.size += bp->s.size;
 62c:	03 53 fc             	add    -0x4(%ebx),%edx
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 632:	8b 53 f8             	mov    -0x8(%ebx),%edx
 635:	89 10                	mov    %edx,(%eax)
 637:	eb da                	jmp    613 <free+0x4a>

00000639 <morecore>:

static Header*
morecore(uint nu)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	53                   	push   %ebx
 63d:	83 ec 04             	sub    $0x4,%esp
 640:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 642:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 647:	77 05                	ja     64e <morecore+0x15>
    nu = 4096;
 649:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 64e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 655:	83 ec 0c             	sub    $0xc,%esp
 658:	50                   	push   %eax
 659:	e8 28 fd ff ff       	call   386 <sbrk>
  if(p == (char*)-1)
 65e:	83 c4 10             	add    $0x10,%esp
 661:	83 f8 ff             	cmp    $0xffffffff,%eax
 664:	74 1c                	je     682 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 666:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 669:	83 c0 08             	add    $0x8,%eax
 66c:	83 ec 0c             	sub    $0xc,%esp
 66f:	50                   	push   %eax
 670:	e8 54 ff ff ff       	call   5c9 <free>
  return freep;
 675:	a1 c0 0a 00 00       	mov    0xac0,%eax
 67a:	83 c4 10             	add    $0x10,%esp
}
 67d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 680:	c9                   	leave  
 681:	c3                   	ret    
    return 0;
 682:	b8 00 00 00 00       	mov    $0x0,%eax
 687:	eb f4                	jmp    67d <morecore+0x44>

00000689 <malloc>:

void*
malloc(uint nbytes)
{
 689:	55                   	push   %ebp
 68a:	89 e5                	mov    %esp,%ebp
 68c:	53                   	push   %ebx
 68d:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	8d 58 07             	lea    0x7(%eax),%ebx
 696:	c1 eb 03             	shr    $0x3,%ebx
 699:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 69c:	8b 0d c0 0a 00 00    	mov    0xac0,%ecx
 6a2:	85 c9                	test   %ecx,%ecx
 6a4:	74 04                	je     6aa <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a6:	8b 01                	mov    (%ecx),%eax
 6a8:	eb 4a                	jmp    6f4 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 6aa:	c7 05 c0 0a 00 00 c4 	movl   $0xac4,0xac0
 6b1:	0a 00 00 
 6b4:	c7 05 c4 0a 00 00 c4 	movl   $0xac4,0xac4
 6bb:	0a 00 00 
    base.s.size = 0;
 6be:	c7 05 c8 0a 00 00 00 	movl   $0x0,0xac8
 6c5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6c8:	b9 c4 0a 00 00       	mov    $0xac4,%ecx
 6cd:	eb d7                	jmp    6a6 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6cf:	74 19                	je     6ea <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d1:	29 da                	sub    %ebx,%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6d6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6d9:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6dc:	89 0d c0 0a 00 00    	mov    %ecx,0xac0
      return (void*)(p + 1);
 6e2:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e8:	c9                   	leave  
 6e9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	89 11                	mov    %edx,(%ecx)
 6ee:	eb ec                	jmp    6dc <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f0:	89 c1                	mov    %eax,%ecx
 6f2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6f4:	8b 50 04             	mov    0x4(%eax),%edx
 6f7:	39 da                	cmp    %ebx,%edx
 6f9:	73 d4                	jae    6cf <malloc+0x46>
    if(p == freep)
 6fb:	39 05 c0 0a 00 00    	cmp    %eax,0xac0
 701:	75 ed                	jne    6f0 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 703:	89 d8                	mov    %ebx,%eax
 705:	e8 2f ff ff ff       	call   639 <morecore>
 70a:	85 c0                	test   %eax,%eax
 70c:	75 e2                	jne    6f0 <malloc+0x67>
 70e:	eb d5                	jmp    6e5 <malloc+0x5c>
