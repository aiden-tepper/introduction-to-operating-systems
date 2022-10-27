
_customtest:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"
#define PGSIZE 4096


int 
main(void){
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	push   -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	56                   	push   %esi
    100e:	53                   	push   %ebx
    100f:	51                   	push   %ecx
    1010:	83 ec 18             	sub    $0x18,%esp
    const uint PAGES_NUM = 5;
    
    // Allocate 5 pages
    char *ptr = sbrk(PGSIZE * PAGES_NUM * sizeof(char));
    1013:	68 00 50 00 00       	push   $0x5000
    1018:	e8 a1 02 00 00       	call   12be <sbrk>
    101d:	89 c3                	mov    %eax,%ebx
    mprotect(ptr, PAGES_NUM);
    101f:	83 c4 08             	add    $0x8,%esp
    1022:	6a 05                	push   $0x5
    1024:	50                   	push   %eax
    1025:	e8 bc 02 00 00       	call   12e6 <mprotect>


    int ppid = getpid();
    102a:	e8 87 02 00 00       	call   12b6 <getpid>
    102f:	89 c6                	mov    %eax,%esi


    if (fork() == 0) {
    1031:	e8 f8 01 00 00       	call   122e <fork>
    1036:	83 c4 10             	add    $0x10,%esp
    1039:	85 c0                	test   %eax,%eax
    103b:	75 32                	jne    106f <main+0x6f>
            printf(1, "asdf");
    103d:	83 ec 08             	sub    $0x8,%esp
    1040:	68 48 16 00 00       	push   $0x1648
    1045:	6a 01                	push   $0x1
    1047:	e8 4f 03 00 00       	call   139b <printf>
        // Should page fault as normally here
        ptr[2 * PGSIZE] = 0xAA;
    104c:	c6 83 00 20 00 00 aa 	movb   $0xaa,0x2000(%ebx)
        printf(1, "XV6_TEST_OUTPUT Seg fault failed to trigger\n");
    1053:	83 c4 08             	add    $0x8,%esp
    1056:	68 70 16 00 00       	push   $0x1670
    105b:	6a 01                	push   $0x1
    105d:	e8 39 03 00 00       	call   139b <printf>
        // Shouldn't reach here
        kill(ppid);
    1062:	89 34 24             	mov    %esi,(%esp)
    1065:	e8 fc 01 00 00       	call   1266 <kill>
        exit();
    106a:	e8 c7 01 00 00       	call   1236 <exit>
    } else {
            printf(1, "jkl;");
    106f:	83 ec 08             	sub    $0x8,%esp
    1072:	68 4d 16 00 00       	push   $0x164d
    1077:	6a 01                	push   $0x1
    1079:	e8 1d 03 00 00       	call   139b <printf>

        wait();
    107e:	e8 bb 01 00 00       	call   123e <wait>
    }

    printf(1, "XV6_TEST_OUTPUT TEST PASS\n");
    1083:	83 c4 08             	add    $0x8,%esp
    1086:	68 52 16 00 00       	push   $0x1652
    108b:	6a 01                	push   $0x1
    108d:	e8 09 03 00 00       	call   139b <printf>

    exit();
    1092:	e8 9f 01 00 00       	call   1236 <exit>

00001097 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1097:	55                   	push   %ebp
    1098:	89 e5                	mov    %esp,%ebp
    109a:	56                   	push   %esi
    109b:	53                   	push   %ebx
    109c:	8b 75 08             	mov    0x8(%ebp),%esi
    109f:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10a2:	89 f0                	mov    %esi,%eax
    10a4:	89 d1                	mov    %edx,%ecx
    10a6:	83 c2 01             	add    $0x1,%edx
    10a9:	89 c3                	mov    %eax,%ebx
    10ab:	83 c0 01             	add    $0x1,%eax
    10ae:	0f b6 09             	movzbl (%ecx),%ecx
    10b1:	88 0b                	mov    %cl,(%ebx)
    10b3:	84 c9                	test   %cl,%cl
    10b5:	75 ed                	jne    10a4 <strcpy+0xd>
    ;
  return os;
}
    10b7:	89 f0                	mov    %esi,%eax
    10b9:	5b                   	pop    %ebx
    10ba:	5e                   	pop    %esi
    10bb:	5d                   	pop    %ebp
    10bc:	c3                   	ret    

000010bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bd:	55                   	push   %ebp
    10be:	89 e5                	mov    %esp,%ebp
    10c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    10c6:	eb 06                	jmp    10ce <strcmp+0x11>
    p++, q++;
    10c8:	83 c1 01             	add    $0x1,%ecx
    10cb:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10ce:	0f b6 01             	movzbl (%ecx),%eax
    10d1:	84 c0                	test   %al,%al
    10d3:	74 04                	je     10d9 <strcmp+0x1c>
    10d5:	3a 02                	cmp    (%edx),%al
    10d7:	74 ef                	je     10c8 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    10d9:	0f b6 c0             	movzbl %al,%eax
    10dc:	0f b6 12             	movzbl (%edx),%edx
    10df:	29 d0                	sub    %edx,%eax
}
    10e1:	5d                   	pop    %ebp
    10e2:	c3                   	ret    

000010e3 <strlen>:

uint
strlen(const char *s)
{
    10e3:	55                   	push   %ebp
    10e4:	89 e5                	mov    %esp,%ebp
    10e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10e9:	b8 00 00 00 00       	mov    $0x0,%eax
    10ee:	eb 03                	jmp    10f3 <strlen+0x10>
    10f0:	83 c0 01             	add    $0x1,%eax
    10f3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
    10f7:	75 f7                	jne    10f0 <strlen+0xd>
    ;
  return n;
}
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    

000010fb <memset>:

void*
memset(void *dst, int c, uint n)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	57                   	push   %edi
    10ff:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1102:	89 d7                	mov    %edx,%edi
    1104:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1107:	8b 45 0c             	mov    0xc(%ebp),%eax
    110a:	fc                   	cld    
    110b:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    110d:	89 d0                	mov    %edx,%eax
    110f:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1112:	c9                   	leave  
    1113:	c3                   	ret    

00001114 <strchr>:

char*
strchr(const char *s, char c)
{
    1114:	55                   	push   %ebp
    1115:	89 e5                	mov    %esp,%ebp
    1117:	8b 45 08             	mov    0x8(%ebp),%eax
    111a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    111e:	eb 03                	jmp    1123 <strchr+0xf>
    1120:	83 c0 01             	add    $0x1,%eax
    1123:	0f b6 10             	movzbl (%eax),%edx
    1126:	84 d2                	test   %dl,%dl
    1128:	74 06                	je     1130 <strchr+0x1c>
    if(*s == c)
    112a:	38 ca                	cmp    %cl,%dl
    112c:	75 f2                	jne    1120 <strchr+0xc>
    112e:	eb 05                	jmp    1135 <strchr+0x21>
      return (char*)s;
  return 0;
    1130:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1135:	5d                   	pop    %ebp
    1136:	c3                   	ret    

00001137 <gets>:

char*
gets(char *buf, int max)
{
    1137:	55                   	push   %ebp
    1138:	89 e5                	mov    %esp,%ebp
    113a:	57                   	push   %edi
    113b:	56                   	push   %esi
    113c:	53                   	push   %ebx
    113d:	83 ec 1c             	sub    $0x1c,%esp
    1140:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1143:	bb 00 00 00 00       	mov    $0x0,%ebx
    1148:	89 de                	mov    %ebx,%esi
    114a:	83 c3 01             	add    $0x1,%ebx
    114d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1150:	7d 2e                	jge    1180 <gets+0x49>
    cc = read(0, &c, 1);
    1152:	83 ec 04             	sub    $0x4,%esp
    1155:	6a 01                	push   $0x1
    1157:	8d 45 e7             	lea    -0x19(%ebp),%eax
    115a:	50                   	push   %eax
    115b:	6a 00                	push   $0x0
    115d:	e8 ec 00 00 00       	call   124e <read>
    if(cc < 1)
    1162:	83 c4 10             	add    $0x10,%esp
    1165:	85 c0                	test   %eax,%eax
    1167:	7e 17                	jle    1180 <gets+0x49>
      break;
    buf[i++] = c;
    1169:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    116d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    1170:	3c 0a                	cmp    $0xa,%al
    1172:	0f 94 c2             	sete   %dl
    1175:	3c 0d                	cmp    $0xd,%al
    1177:	0f 94 c0             	sete   %al
    117a:	08 c2                	or     %al,%dl
    117c:	74 ca                	je     1148 <gets+0x11>
    buf[i++] = c;
    117e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1180:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    1184:	89 f8                	mov    %edi,%eax
    1186:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1189:	5b                   	pop    %ebx
    118a:	5e                   	pop    %esi
    118b:	5f                   	pop    %edi
    118c:	5d                   	pop    %ebp
    118d:	c3                   	ret    

0000118e <stat>:

int
stat(const char *n, struct stat *st)
{
    118e:	55                   	push   %ebp
    118f:	89 e5                	mov    %esp,%ebp
    1191:	56                   	push   %esi
    1192:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1193:	83 ec 08             	sub    $0x8,%esp
    1196:	6a 00                	push   $0x0
    1198:	ff 75 08             	push   0x8(%ebp)
    119b:	e8 d6 00 00 00       	call   1276 <open>
  if(fd < 0)
    11a0:	83 c4 10             	add    $0x10,%esp
    11a3:	85 c0                	test   %eax,%eax
    11a5:	78 24                	js     11cb <stat+0x3d>
    11a7:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    11a9:	83 ec 08             	sub    $0x8,%esp
    11ac:	ff 75 0c             	push   0xc(%ebp)
    11af:	50                   	push   %eax
    11b0:	e8 d9 00 00 00       	call   128e <fstat>
    11b5:	89 c6                	mov    %eax,%esi
  close(fd);
    11b7:	89 1c 24             	mov    %ebx,(%esp)
    11ba:	e8 9f 00 00 00       	call   125e <close>
  return r;
    11bf:	83 c4 10             	add    $0x10,%esp
}
    11c2:	89 f0                	mov    %esi,%eax
    11c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11c7:	5b                   	pop    %ebx
    11c8:	5e                   	pop    %esi
    11c9:	5d                   	pop    %ebp
    11ca:	c3                   	ret    
    return -1;
    11cb:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11d0:	eb f0                	jmp    11c2 <stat+0x34>

000011d2 <atoi>:

int
atoi(const char *s)
{
    11d2:	55                   	push   %ebp
    11d3:	89 e5                	mov    %esp,%ebp
    11d5:	53                   	push   %ebx
    11d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    11d9:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    11de:	eb 10                	jmp    11f0 <atoi+0x1e>
    n = n*10 + *s++ - '0';
    11e0:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
    11e3:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
    11e6:	83 c1 01             	add    $0x1,%ecx
    11e9:	0f be c0             	movsbl %al,%eax
    11ec:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
    11f0:	0f b6 01             	movzbl (%ecx),%eax
    11f3:	8d 58 d0             	lea    -0x30(%eax),%ebx
    11f6:	80 fb 09             	cmp    $0x9,%bl
    11f9:	76 e5                	jbe    11e0 <atoi+0xe>
  return n;
}
    11fb:	89 d0                	mov    %edx,%eax
    11fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1200:	c9                   	leave  
    1201:	c3                   	ret    

00001202 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1202:	55                   	push   %ebp
    1203:	89 e5                	mov    %esp,%ebp
    1205:	56                   	push   %esi
    1206:	53                   	push   %ebx
    1207:	8b 75 08             	mov    0x8(%ebp),%esi
    120a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    120d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
    1210:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
    1212:	eb 0d                	jmp    1221 <memmove+0x1f>
    *dst++ = *src++;
    1214:	0f b6 01             	movzbl (%ecx),%eax
    1217:	88 02                	mov    %al,(%edx)
    1219:	8d 49 01             	lea    0x1(%ecx),%ecx
    121c:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
    121f:	89 d8                	mov    %ebx,%eax
    1221:	8d 58 ff             	lea    -0x1(%eax),%ebx
    1224:	85 c0                	test   %eax,%eax
    1226:	7f ec                	jg     1214 <memmove+0x12>
  return vdst;
}
    1228:	89 f0                	mov    %esi,%eax
    122a:	5b                   	pop    %ebx
    122b:	5e                   	pop    %esi
    122c:	5d                   	pop    %ebp
    122d:	c3                   	ret    

0000122e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    122e:	b8 01 00 00 00       	mov    $0x1,%eax
    1233:	cd 40                	int    $0x40
    1235:	c3                   	ret    

00001236 <exit>:
SYSCALL(exit)
    1236:	b8 02 00 00 00       	mov    $0x2,%eax
    123b:	cd 40                	int    $0x40
    123d:	c3                   	ret    

0000123e <wait>:
SYSCALL(wait)
    123e:	b8 03 00 00 00       	mov    $0x3,%eax
    1243:	cd 40                	int    $0x40
    1245:	c3                   	ret    

00001246 <pipe>:
SYSCALL(pipe)
    1246:	b8 04 00 00 00       	mov    $0x4,%eax
    124b:	cd 40                	int    $0x40
    124d:	c3                   	ret    

0000124e <read>:
SYSCALL(read)
    124e:	b8 05 00 00 00       	mov    $0x5,%eax
    1253:	cd 40                	int    $0x40
    1255:	c3                   	ret    

00001256 <write>:
SYSCALL(write)
    1256:	b8 10 00 00 00       	mov    $0x10,%eax
    125b:	cd 40                	int    $0x40
    125d:	c3                   	ret    

0000125e <close>:
SYSCALL(close)
    125e:	b8 15 00 00 00       	mov    $0x15,%eax
    1263:	cd 40                	int    $0x40
    1265:	c3                   	ret    

00001266 <kill>:
SYSCALL(kill)
    1266:	b8 06 00 00 00       	mov    $0x6,%eax
    126b:	cd 40                	int    $0x40
    126d:	c3                   	ret    

0000126e <exec>:
SYSCALL(exec)
    126e:	b8 07 00 00 00       	mov    $0x7,%eax
    1273:	cd 40                	int    $0x40
    1275:	c3                   	ret    

00001276 <open>:
SYSCALL(open)
    1276:	b8 0f 00 00 00       	mov    $0xf,%eax
    127b:	cd 40                	int    $0x40
    127d:	c3                   	ret    

0000127e <mknod>:
SYSCALL(mknod)
    127e:	b8 11 00 00 00       	mov    $0x11,%eax
    1283:	cd 40                	int    $0x40
    1285:	c3                   	ret    

00001286 <unlink>:
SYSCALL(unlink)
    1286:	b8 12 00 00 00       	mov    $0x12,%eax
    128b:	cd 40                	int    $0x40
    128d:	c3                   	ret    

0000128e <fstat>:
SYSCALL(fstat)
    128e:	b8 08 00 00 00       	mov    $0x8,%eax
    1293:	cd 40                	int    $0x40
    1295:	c3                   	ret    

00001296 <link>:
SYSCALL(link)
    1296:	b8 13 00 00 00       	mov    $0x13,%eax
    129b:	cd 40                	int    $0x40
    129d:	c3                   	ret    

0000129e <mkdir>:
SYSCALL(mkdir)
    129e:	b8 14 00 00 00       	mov    $0x14,%eax
    12a3:	cd 40                	int    $0x40
    12a5:	c3                   	ret    

000012a6 <chdir>:
SYSCALL(chdir)
    12a6:	b8 09 00 00 00       	mov    $0x9,%eax
    12ab:	cd 40                	int    $0x40
    12ad:	c3                   	ret    

000012ae <dup>:
SYSCALL(dup)
    12ae:	b8 0a 00 00 00       	mov    $0xa,%eax
    12b3:	cd 40                	int    $0x40
    12b5:	c3                   	ret    

000012b6 <getpid>:
SYSCALL(getpid)
    12b6:	b8 0b 00 00 00       	mov    $0xb,%eax
    12bb:	cd 40                	int    $0x40
    12bd:	c3                   	ret    

000012be <sbrk>:
SYSCALL(sbrk)
    12be:	b8 0c 00 00 00       	mov    $0xc,%eax
    12c3:	cd 40                	int    $0x40
    12c5:	c3                   	ret    

000012c6 <sleep>:
SYSCALL(sleep)
    12c6:	b8 0d 00 00 00       	mov    $0xd,%eax
    12cb:	cd 40                	int    $0x40
    12cd:	c3                   	ret    

000012ce <uptime>:
SYSCALL(uptime)
    12ce:	b8 0e 00 00 00       	mov    $0xe,%eax
    12d3:	cd 40                	int    $0x40
    12d5:	c3                   	ret    

000012d6 <settickets>:
SYSCALL(settickets)
    12d6:	b8 16 00 00 00       	mov    $0x16,%eax
    12db:	cd 40                	int    $0x40
    12dd:	c3                   	ret    

000012de <getpinfo>:
SYSCALL(getpinfo)
    12de:	b8 17 00 00 00       	mov    $0x17,%eax
    12e3:	cd 40                	int    $0x40
    12e5:	c3                   	ret    

000012e6 <mprotect>:
SYSCALL(mprotect)
    12e6:	b8 18 00 00 00       	mov    $0x18,%eax
    12eb:	cd 40                	int    $0x40
    12ed:	c3                   	ret    

000012ee <munprotect>:
SYSCALL(munprotect)
    12ee:	b8 19 00 00 00       	mov    $0x19,%eax
    12f3:	cd 40                	int    $0x40
    12f5:	c3                   	ret    

000012f6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    12f6:	55                   	push   %ebp
    12f7:	89 e5                	mov    %esp,%ebp
    12f9:	83 ec 1c             	sub    $0x1c,%esp
    12fc:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    12ff:	6a 01                	push   $0x1
    1301:	8d 55 f4             	lea    -0xc(%ebp),%edx
    1304:	52                   	push   %edx
    1305:	50                   	push   %eax
    1306:	e8 4b ff ff ff       	call   1256 <write>
}
    130b:	83 c4 10             	add    $0x10,%esp
    130e:	c9                   	leave  
    130f:	c3                   	ret    

00001310 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	57                   	push   %edi
    1314:	56                   	push   %esi
    1315:	53                   	push   %ebx
    1316:	83 ec 2c             	sub    $0x2c,%esp
    1319:	89 45 d0             	mov    %eax,-0x30(%ebp)
    131c:	89 d0                	mov    %edx,%eax
    131e:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1320:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1324:	0f 95 c1             	setne  %cl
    1327:	c1 ea 1f             	shr    $0x1f,%edx
    132a:	84 d1                	test   %dl,%cl
    132c:	74 44                	je     1372 <printint+0x62>
    neg = 1;
    x = -xx;
    132e:	f7 d8                	neg    %eax
    1330:	89 c1                	mov    %eax,%ecx
    neg = 1;
    1332:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1339:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    133e:	89 c8                	mov    %ecx,%eax
    1340:	ba 00 00 00 00       	mov    $0x0,%edx
    1345:	f7 f6                	div    %esi
    1347:	89 df                	mov    %ebx,%edi
    1349:	83 c3 01             	add    $0x1,%ebx
    134c:	0f b6 92 fc 16 00 00 	movzbl 0x16fc(%edx),%edx
    1353:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    1357:	89 ca                	mov    %ecx,%edx
    1359:	89 c1                	mov    %eax,%ecx
    135b:	39 d6                	cmp    %edx,%esi
    135d:	76 df                	jbe    133e <printint+0x2e>
  if(neg)
    135f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    1363:	74 31                	je     1396 <printint+0x86>
    buf[i++] = '-';
    1365:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    136a:	8d 5f 02             	lea    0x2(%edi),%ebx
    136d:	8b 75 d0             	mov    -0x30(%ebp),%esi
    1370:	eb 17                	jmp    1389 <printint+0x79>
    x = xx;
    1372:	89 c1                	mov    %eax,%ecx
  neg = 0;
    1374:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    137b:	eb bc                	jmp    1339 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
    137d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    1382:	89 f0                	mov    %esi,%eax
    1384:	e8 6d ff ff ff       	call   12f6 <putc>
  while(--i >= 0)
    1389:	83 eb 01             	sub    $0x1,%ebx
    138c:	79 ef                	jns    137d <printint+0x6d>
}
    138e:	83 c4 2c             	add    $0x2c,%esp
    1391:	5b                   	pop    %ebx
    1392:	5e                   	pop    %esi
    1393:	5f                   	pop    %edi
    1394:	5d                   	pop    %ebp
    1395:	c3                   	ret    
    1396:	8b 75 d0             	mov    -0x30(%ebp),%esi
    1399:	eb ee                	jmp    1389 <printint+0x79>

0000139b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    139b:	55                   	push   %ebp
    139c:	89 e5                	mov    %esp,%ebp
    139e:	57                   	push   %edi
    139f:	56                   	push   %esi
    13a0:	53                   	push   %ebx
    13a1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    13a4:	8d 45 10             	lea    0x10(%ebp),%eax
    13a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    13aa:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    13af:	bb 00 00 00 00       	mov    $0x0,%ebx
    13b4:	eb 14                	jmp    13ca <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    13b6:	89 fa                	mov    %edi,%edx
    13b8:	8b 45 08             	mov    0x8(%ebp),%eax
    13bb:	e8 36 ff ff ff       	call   12f6 <putc>
    13c0:	eb 05                	jmp    13c7 <printf+0x2c>
      }
    } else if(state == '%'){
    13c2:	83 fe 25             	cmp    $0x25,%esi
    13c5:	74 25                	je     13ec <printf+0x51>
  for(i = 0; fmt[i]; i++){
    13c7:	83 c3 01             	add    $0x1,%ebx
    13ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cd:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
    13d1:	84 c0                	test   %al,%al
    13d3:	0f 84 20 01 00 00    	je     14f9 <printf+0x15e>
    c = fmt[i] & 0xff;
    13d9:	0f be f8             	movsbl %al,%edi
    13dc:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    13df:	85 f6                	test   %esi,%esi
    13e1:	75 df                	jne    13c2 <printf+0x27>
      if(c == '%'){
    13e3:	83 f8 25             	cmp    $0x25,%eax
    13e6:	75 ce                	jne    13b6 <printf+0x1b>
        state = '%';
    13e8:	89 c6                	mov    %eax,%esi
    13ea:	eb db                	jmp    13c7 <printf+0x2c>
      if(c == 'd'){
    13ec:	83 f8 25             	cmp    $0x25,%eax
    13ef:	0f 84 cf 00 00 00    	je     14c4 <printf+0x129>
    13f5:	0f 8c dd 00 00 00    	jl     14d8 <printf+0x13d>
    13fb:	83 f8 78             	cmp    $0x78,%eax
    13fe:	0f 8f d4 00 00 00    	jg     14d8 <printf+0x13d>
    1404:	83 f8 63             	cmp    $0x63,%eax
    1407:	0f 8c cb 00 00 00    	jl     14d8 <printf+0x13d>
    140d:	83 e8 63             	sub    $0x63,%eax
    1410:	83 f8 15             	cmp    $0x15,%eax
    1413:	0f 87 bf 00 00 00    	ja     14d8 <printf+0x13d>
    1419:	ff 24 85 a4 16 00 00 	jmp    *0x16a4(,%eax,4)
        printint(fd, *ap, 10, 1);
    1420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    1423:	8b 17                	mov    (%edi),%edx
    1425:	83 ec 0c             	sub    $0xc,%esp
    1428:	6a 01                	push   $0x1
    142a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    142f:	8b 45 08             	mov    0x8(%ebp),%eax
    1432:	e8 d9 fe ff ff       	call   1310 <printint>
        ap++;
    1437:	83 c7 04             	add    $0x4,%edi
    143a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    143d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1440:	be 00 00 00 00       	mov    $0x0,%esi
    1445:	eb 80                	jmp    13c7 <printf+0x2c>
        printint(fd, *ap, 16, 0);
    1447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    144a:	8b 17                	mov    (%edi),%edx
    144c:	83 ec 0c             	sub    $0xc,%esp
    144f:	6a 00                	push   $0x0
    1451:	b9 10 00 00 00       	mov    $0x10,%ecx
    1456:	8b 45 08             	mov    0x8(%ebp),%eax
    1459:	e8 b2 fe ff ff       	call   1310 <printint>
        ap++;
    145e:	83 c7 04             	add    $0x4,%edi
    1461:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    1464:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1467:	be 00 00 00 00       	mov    $0x0,%esi
    146c:	e9 56 ff ff ff       	jmp    13c7 <printf+0x2c>
        s = (char*)*ap;
    1471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1474:	8b 30                	mov    (%eax),%esi
        ap++;
    1476:	83 c0 04             	add    $0x4,%eax
    1479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    147c:	85 f6                	test   %esi,%esi
    147e:	75 15                	jne    1495 <printf+0xfa>
          s = "(null)";
    1480:	be 9d 16 00 00       	mov    $0x169d,%esi
    1485:	eb 0e                	jmp    1495 <printf+0xfa>
          putc(fd, *s);
    1487:	0f be d2             	movsbl %dl,%edx
    148a:	8b 45 08             	mov    0x8(%ebp),%eax
    148d:	e8 64 fe ff ff       	call   12f6 <putc>
          s++;
    1492:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
    1495:	0f b6 16             	movzbl (%esi),%edx
    1498:	84 d2                	test   %dl,%dl
    149a:	75 eb                	jne    1487 <printf+0xec>
      state = 0;
    149c:	be 00 00 00 00       	mov    $0x0,%esi
    14a1:	e9 21 ff ff ff       	jmp    13c7 <printf+0x2c>
        putc(fd, *ap);
    14a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    14a9:	0f be 17             	movsbl (%edi),%edx
    14ac:	8b 45 08             	mov    0x8(%ebp),%eax
    14af:	e8 42 fe ff ff       	call   12f6 <putc>
        ap++;
    14b4:	83 c7 04             	add    $0x4,%edi
    14b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    14ba:	be 00 00 00 00       	mov    $0x0,%esi
    14bf:	e9 03 ff ff ff       	jmp    13c7 <printf+0x2c>
        putc(fd, c);
    14c4:	89 fa                	mov    %edi,%edx
    14c6:	8b 45 08             	mov    0x8(%ebp),%eax
    14c9:	e8 28 fe ff ff       	call   12f6 <putc>
      state = 0;
    14ce:	be 00 00 00 00       	mov    $0x0,%esi
    14d3:	e9 ef fe ff ff       	jmp    13c7 <printf+0x2c>
        putc(fd, '%');
    14d8:	ba 25 00 00 00       	mov    $0x25,%edx
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
    14e0:	e8 11 fe ff ff       	call   12f6 <putc>
        putc(fd, c);
    14e5:	89 fa                	mov    %edi,%edx
    14e7:	8b 45 08             	mov    0x8(%ebp),%eax
    14ea:	e8 07 fe ff ff       	call   12f6 <putc>
      state = 0;
    14ef:	be 00 00 00 00       	mov    $0x0,%esi
    14f4:	e9 ce fe ff ff       	jmp    13c7 <printf+0x2c>
    }
  }
}
    14f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14fc:	5b                   	pop    %ebx
    14fd:	5e                   	pop    %esi
    14fe:	5f                   	pop    %edi
    14ff:	5d                   	pop    %ebp
    1500:	c3                   	ret    

00001501 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1501:	55                   	push   %ebp
    1502:	89 e5                	mov    %esp,%ebp
    1504:	57                   	push   %edi
    1505:	56                   	push   %esi
    1506:	53                   	push   %ebx
    1507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    150a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    150d:	a1 a4 19 00 00       	mov    0x19a4,%eax
    1512:	eb 02                	jmp    1516 <free+0x15>
    1514:	89 d0                	mov    %edx,%eax
    1516:	39 c8                	cmp    %ecx,%eax
    1518:	73 04                	jae    151e <free+0x1d>
    151a:	39 08                	cmp    %ecx,(%eax)
    151c:	77 12                	ja     1530 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    151e:	8b 10                	mov    (%eax),%edx
    1520:	39 c2                	cmp    %eax,%edx
    1522:	77 f0                	ja     1514 <free+0x13>
    1524:	39 c8                	cmp    %ecx,%eax
    1526:	72 08                	jb     1530 <free+0x2f>
    1528:	39 ca                	cmp    %ecx,%edx
    152a:	77 04                	ja     1530 <free+0x2f>
    152c:	89 d0                	mov    %edx,%eax
    152e:	eb e6                	jmp    1516 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1530:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1533:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1536:	8b 10                	mov    (%eax),%edx
    1538:	39 d7                	cmp    %edx,%edi
    153a:	74 19                	je     1555 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    153c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    153f:	8b 50 04             	mov    0x4(%eax),%edx
    1542:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1545:	39 ce                	cmp    %ecx,%esi
    1547:	74 1b                	je     1564 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1549:	89 08                	mov    %ecx,(%eax)
  freep = p;
    154b:	a3 a4 19 00 00       	mov    %eax,0x19a4
}
    1550:	5b                   	pop    %ebx
    1551:	5e                   	pop    %esi
    1552:	5f                   	pop    %edi
    1553:	5d                   	pop    %ebp
    1554:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1555:	03 72 04             	add    0x4(%edx),%esi
    1558:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    155b:	8b 10                	mov    (%eax),%edx
    155d:	8b 12                	mov    (%edx),%edx
    155f:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1562:	eb db                	jmp    153f <free+0x3e>
    p->s.size += bp->s.size;
    1564:	03 53 fc             	add    -0x4(%ebx),%edx
    1567:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    156a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    156d:	89 10                	mov    %edx,(%eax)
    156f:	eb da                	jmp    154b <free+0x4a>

00001571 <morecore>:

static Header*
morecore(uint nu)
{
    1571:	55                   	push   %ebp
    1572:	89 e5                	mov    %esp,%ebp
    1574:	53                   	push   %ebx
    1575:	83 ec 04             	sub    $0x4,%esp
    1578:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    157a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    157f:	77 05                	ja     1586 <morecore+0x15>
    nu = 4096;
    1581:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    1586:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    158d:	83 ec 0c             	sub    $0xc,%esp
    1590:	50                   	push   %eax
    1591:	e8 28 fd ff ff       	call   12be <sbrk>
  if(p == (char*)-1)
    1596:	83 c4 10             	add    $0x10,%esp
    1599:	83 f8 ff             	cmp    $0xffffffff,%eax
    159c:	74 1c                	je     15ba <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    159e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    15a1:	83 c0 08             	add    $0x8,%eax
    15a4:	83 ec 0c             	sub    $0xc,%esp
    15a7:	50                   	push   %eax
    15a8:	e8 54 ff ff ff       	call   1501 <free>
  return freep;
    15ad:	a1 a4 19 00 00       	mov    0x19a4,%eax
    15b2:	83 c4 10             	add    $0x10,%esp
}
    15b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15b8:	c9                   	leave  
    15b9:	c3                   	ret    
    return 0;
    15ba:	b8 00 00 00 00       	mov    $0x0,%eax
    15bf:	eb f4                	jmp    15b5 <morecore+0x44>

000015c1 <malloc>:

void*
malloc(uint nbytes)
{
    15c1:	55                   	push   %ebp
    15c2:	89 e5                	mov    %esp,%ebp
    15c4:	53                   	push   %ebx
    15c5:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15c8:	8b 45 08             	mov    0x8(%ebp),%eax
    15cb:	8d 58 07             	lea    0x7(%eax),%ebx
    15ce:	c1 eb 03             	shr    $0x3,%ebx
    15d1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15d4:	8b 0d a4 19 00 00    	mov    0x19a4,%ecx
    15da:	85 c9                	test   %ecx,%ecx
    15dc:	74 04                	je     15e2 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15de:	8b 01                	mov    (%ecx),%eax
    15e0:	eb 4a                	jmp    162c <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
    15e2:	c7 05 a4 19 00 00 a8 	movl   $0x19a8,0x19a4
    15e9:	19 00 00 
    15ec:	c7 05 a8 19 00 00 a8 	movl   $0x19a8,0x19a8
    15f3:	19 00 00 
    base.s.size = 0;
    15f6:	c7 05 ac 19 00 00 00 	movl   $0x0,0x19ac
    15fd:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1600:	b9 a8 19 00 00       	mov    $0x19a8,%ecx
    1605:	eb d7                	jmp    15de <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    1607:	74 19                	je     1622 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1609:	29 da                	sub    %ebx,%edx
    160b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    160e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    1611:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1614:	89 0d a4 19 00 00    	mov    %ecx,0x19a4
      return (void*)(p + 1);
    161a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1620:	c9                   	leave  
    1621:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1622:	8b 10                	mov    (%eax),%edx
    1624:	89 11                	mov    %edx,(%ecx)
    1626:	eb ec                	jmp    1614 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1628:	89 c1                	mov    %eax,%ecx
    162a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    162c:	8b 50 04             	mov    0x4(%eax),%edx
    162f:	39 da                	cmp    %ebx,%edx
    1631:	73 d4                	jae    1607 <malloc+0x46>
    if(p == freep)
    1633:	39 05 a4 19 00 00    	cmp    %eax,0x19a4
    1639:	75 ed                	jne    1628 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
    163b:	89 d8                	mov    %ebx,%eax
    163d:	e8 2f ff ff ff       	call   1571 <morecore>
    1642:	85 c0                	test   %eax,%eax
    1644:	75 e2                	jne    1628 <malloc+0x67>
    1646:	eb d5                	jmp    161d <malloc+0x5c>
