
_forktest:     file format elf32-i386


Disassembly of section .text:

00001000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 10             	sub    $0x10,%esp
    1007:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
    100a:	53                   	push   %ebx
    100b:	e8 25 01 00 00       	call   1135 <strlen>
    1010:	83 c4 0c             	add    $0xc,%esp
    1013:	50                   	push   %eax
    1014:	53                   	push   %ebx
    1015:	ff 75 08             	push   0x8(%ebp)
    1018:	e8 8b 02 00 00       	call   12a8 <write>
}
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1023:	c9                   	leave  
    1024:	c3                   	ret    

00001025 <forktest>:

void
forktest(void)
{
    1025:	55                   	push   %ebp
    1026:	89 e5                	mov    %esp,%ebp
    1028:	53                   	push   %ebx
    1029:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    102c:	68 48 13 00 00       	push   $0x1348
    1031:	6a 01                	push   $0x1
    1033:	e8 c8 ff ff ff       	call   1000 <printf>

  for(n=0; n<N; n++){
    1038:	83 c4 10             	add    $0x10,%esp
    103b:	bb 00 00 00 00       	mov    $0x0,%ebx
    1040:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    1046:	7f 15                	jg     105d <forktest+0x38>
    pid = fork();
    1048:	e8 33 02 00 00       	call   1280 <fork>
    if(pid < 0)
    104d:	85 c0                	test   %eax,%eax
    104f:	78 0c                	js     105d <forktest+0x38>
      break;
    if(pid == 0)
    1051:	74 05                	je     1058 <forktest+0x33>
  for(n=0; n<N; n++){
    1053:	83 c3 01             	add    $0x1,%ebx
    1056:	eb e8                	jmp    1040 <forktest+0x1b>
      exit();
    1058:	e8 2b 02 00 00       	call   1288 <exit>
  }

  if(n == N){
    105d:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    1063:	74 12                	je     1077 <forktest+0x52>
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
    1065:	85 db                	test   %ebx,%ebx
    1067:	7e 3b                	jle    10a4 <forktest+0x7f>
    if(wait() < 0){
    1069:	e8 22 02 00 00       	call   1290 <wait>
    106e:	85 c0                	test   %eax,%eax
    1070:	78 1e                	js     1090 <forktest+0x6b>
  for(; n > 0; n--){
    1072:	83 eb 01             	sub    $0x1,%ebx
    1075:	eb ee                	jmp    1065 <forktest+0x40>
    printf(1, "fork claimed to work N times!\n", N);
    1077:	83 ec 04             	sub    $0x4,%esp
    107a:	68 e8 03 00 00       	push   $0x3e8
    107f:	68 88 13 00 00       	push   $0x1388
    1084:	6a 01                	push   $0x1
    1086:	e8 75 ff ff ff       	call   1000 <printf>
    exit();
    108b:	e8 f8 01 00 00       	call   1288 <exit>
      printf(1, "wait stopped early\n");
    1090:	83 ec 08             	sub    $0x8,%esp
    1093:	68 53 13 00 00       	push   $0x1353
    1098:	6a 01                	push   $0x1
    109a:	e8 61 ff ff ff       	call   1000 <printf>
      exit();
    109f:	e8 e4 01 00 00       	call   1288 <exit>
    }
  }

  if(wait() != -1){
    10a4:	e8 e7 01 00 00       	call   1290 <wait>
    10a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    10ac:	75 17                	jne    10c5 <forktest+0xa0>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    10ae:	83 ec 08             	sub    $0x8,%esp
    10b1:	68 7a 13 00 00       	push   $0x137a
    10b6:	6a 01                	push   $0x1
    10b8:	e8 43 ff ff ff       	call   1000 <printf>
}
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10c3:	c9                   	leave  
    10c4:	c3                   	ret    
    printf(1, "wait got too many\n");
    10c5:	83 ec 08             	sub    $0x8,%esp
    10c8:	68 67 13 00 00       	push   $0x1367
    10cd:	6a 01                	push   $0x1
    10cf:	e8 2c ff ff ff       	call   1000 <printf>
    exit();
    10d4:	e8 af 01 00 00       	call   1288 <exit>

000010d9 <main>:

int
main(void)
{
    10d9:	55                   	push   %ebp
    10da:	89 e5                	mov    %esp,%ebp
    10dc:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
    10df:	e8 41 ff ff ff       	call   1025 <forktest>
  exit();
    10e4:	e8 9f 01 00 00       	call   1288 <exit>

000010e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10e9:	55                   	push   %ebp
    10ea:	89 e5                	mov    %esp,%ebp
    10ec:	56                   	push   %esi
    10ed:	53                   	push   %ebx
    10ee:	8b 75 08             	mov    0x8(%ebp),%esi
    10f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10f4:	89 f0                	mov    %esi,%eax
    10f6:	89 d1                	mov    %edx,%ecx
    10f8:	83 c2 01             	add    $0x1,%edx
    10fb:	89 c3                	mov    %eax,%ebx
    10fd:	83 c0 01             	add    $0x1,%eax
    1100:	0f b6 09             	movzbl (%ecx),%ecx
    1103:	88 0b                	mov    %cl,(%ebx)
    1105:	84 c9                	test   %cl,%cl
    1107:	75 ed                	jne    10f6 <strcpy+0xd>
    ;
  return os;
}
    1109:	89 f0                	mov    %esi,%eax
    110b:	5b                   	pop    %ebx
    110c:	5e                   	pop    %esi
    110d:	5d                   	pop    %ebp
    110e:	c3                   	ret    

0000110f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1115:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1118:	eb 06                	jmp    1120 <strcmp+0x11>
    p++, q++;
    111a:	83 c1 01             	add    $0x1,%ecx
    111d:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1120:	0f b6 01             	movzbl (%ecx),%eax
    1123:	84 c0                	test   %al,%al
    1125:	74 04                	je     112b <strcmp+0x1c>
    1127:	3a 02                	cmp    (%edx),%al
    1129:	74 ef                	je     111a <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    112b:	0f b6 c0             	movzbl %al,%eax
    112e:	0f b6 12             	movzbl (%edx),%edx
    1131:	29 d0                	sub    %edx,%eax
}
    1133:	5d                   	pop    %ebp
    1134:	c3                   	ret    

00001135 <strlen>:

uint
strlen(const char *s)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    113b:	b8 00 00 00 00       	mov    $0x0,%eax
    1140:	eb 03                	jmp    1145 <strlen+0x10>
    1142:	83 c0 01             	add    $0x1,%eax
    1145:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
    1149:	75 f7                	jne    1142 <strlen+0xd>
    ;
  return n;
}
    114b:	5d                   	pop    %ebp
    114c:	c3                   	ret    

0000114d <memset>:

void*
memset(void *dst, int c, uint n)
{
    114d:	55                   	push   %ebp
    114e:	89 e5                	mov    %esp,%ebp
    1150:	57                   	push   %edi
    1151:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1154:	89 d7                	mov    %edx,%edi
    1156:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1159:	8b 45 0c             	mov    0xc(%ebp),%eax
    115c:	fc                   	cld    
    115d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    115f:	89 d0                	mov    %edx,%eax
    1161:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1164:	c9                   	leave  
    1165:	c3                   	ret    

00001166 <strchr>:

char*
strchr(const char *s, char c)
{
    1166:	55                   	push   %ebp
    1167:	89 e5                	mov    %esp,%ebp
    1169:	8b 45 08             	mov    0x8(%ebp),%eax
    116c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    1170:	eb 03                	jmp    1175 <strchr+0xf>
    1172:	83 c0 01             	add    $0x1,%eax
    1175:	0f b6 10             	movzbl (%eax),%edx
    1178:	84 d2                	test   %dl,%dl
    117a:	74 06                	je     1182 <strchr+0x1c>
    if(*s == c)
    117c:	38 ca                	cmp    %cl,%dl
    117e:	75 f2                	jne    1172 <strchr+0xc>
    1180:	eb 05                	jmp    1187 <strchr+0x21>
      return (char*)s;
  return 0;
    1182:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1187:	5d                   	pop    %ebp
    1188:	c3                   	ret    

00001189 <gets>:

char*
gets(char *buf, int max)
{
    1189:	55                   	push   %ebp
    118a:	89 e5                	mov    %esp,%ebp
    118c:	57                   	push   %edi
    118d:	56                   	push   %esi
    118e:	53                   	push   %ebx
    118f:	83 ec 1c             	sub    $0x1c,%esp
    1192:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1195:	bb 00 00 00 00       	mov    $0x0,%ebx
    119a:	89 de                	mov    %ebx,%esi
    119c:	83 c3 01             	add    $0x1,%ebx
    119f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11a2:	7d 2e                	jge    11d2 <gets+0x49>
    cc = read(0, &c, 1);
    11a4:	83 ec 04             	sub    $0x4,%esp
    11a7:	6a 01                	push   $0x1
    11a9:	8d 45 e7             	lea    -0x19(%ebp),%eax
    11ac:	50                   	push   %eax
    11ad:	6a 00                	push   $0x0
    11af:	e8 ec 00 00 00       	call   12a0 <read>
    if(cc < 1)
    11b4:	83 c4 10             	add    $0x10,%esp
    11b7:	85 c0                	test   %eax,%eax
    11b9:	7e 17                	jle    11d2 <gets+0x49>
      break;
    buf[i++] = c;
    11bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11bf:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    11c2:	3c 0a                	cmp    $0xa,%al
    11c4:	0f 94 c2             	sete   %dl
    11c7:	3c 0d                	cmp    $0xd,%al
    11c9:	0f 94 c0             	sete   %al
    11cc:	08 c2                	or     %al,%dl
    11ce:	74 ca                	je     119a <gets+0x11>
    buf[i++] = c;
    11d0:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    11d2:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    11d6:	89 f8                	mov    %edi,%eax
    11d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11db:	5b                   	pop    %ebx
    11dc:	5e                   	pop    %esi
    11dd:	5f                   	pop    %edi
    11de:	5d                   	pop    %ebp
    11df:	c3                   	ret    

000011e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	56                   	push   %esi
    11e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11e5:	83 ec 08             	sub    $0x8,%esp
    11e8:	6a 00                	push   $0x0
    11ea:	ff 75 08             	push   0x8(%ebp)
    11ed:	e8 d6 00 00 00       	call   12c8 <open>
  if(fd < 0)
    11f2:	83 c4 10             	add    $0x10,%esp
    11f5:	85 c0                	test   %eax,%eax
    11f7:	78 24                	js     121d <stat+0x3d>
    11f9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	ff 75 0c             	push   0xc(%ebp)
    1201:	50                   	push   %eax
    1202:	e8 d9 00 00 00       	call   12e0 <fstat>
    1207:	89 c6                	mov    %eax,%esi
  close(fd);
    1209:	89 1c 24             	mov    %ebx,(%esp)
    120c:	e8 9f 00 00 00       	call   12b0 <close>
  return r;
    1211:	83 c4 10             	add    $0x10,%esp
}
    1214:	89 f0                	mov    %esi,%eax
    1216:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1219:	5b                   	pop    %ebx
    121a:	5e                   	pop    %esi
    121b:	5d                   	pop    %ebp
    121c:	c3                   	ret    
    return -1;
    121d:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1222:	eb f0                	jmp    1214 <stat+0x34>

00001224 <atoi>:

int
atoi(const char *s)
{
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	53                   	push   %ebx
    1228:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    122b:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    1230:	eb 10                	jmp    1242 <atoi+0x1e>
    n = n*10 + *s++ - '0';
    1232:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
    1235:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
    1238:	83 c1 01             	add    $0x1,%ecx
    123b:	0f be c0             	movsbl %al,%eax
    123e:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
    1242:	0f b6 01             	movzbl (%ecx),%eax
    1245:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1248:	80 fb 09             	cmp    $0x9,%bl
    124b:	76 e5                	jbe    1232 <atoi+0xe>
  return n;
}
    124d:	89 d0                	mov    %edx,%eax
    124f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1252:	c9                   	leave  
    1253:	c3                   	ret    

00001254 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1254:	55                   	push   %ebp
    1255:	89 e5                	mov    %esp,%ebp
    1257:	56                   	push   %esi
    1258:	53                   	push   %ebx
    1259:	8b 75 08             	mov    0x8(%ebp),%esi
    125c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    125f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
    1262:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
    1264:	eb 0d                	jmp    1273 <memmove+0x1f>
    *dst++ = *src++;
    1266:	0f b6 01             	movzbl (%ecx),%eax
    1269:	88 02                	mov    %al,(%edx)
    126b:	8d 49 01             	lea    0x1(%ecx),%ecx
    126e:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
    1271:	89 d8                	mov    %ebx,%eax
    1273:	8d 58 ff             	lea    -0x1(%eax),%ebx
    1276:	85 c0                	test   %eax,%eax
    1278:	7f ec                	jg     1266 <memmove+0x12>
  return vdst;
}
    127a:	89 f0                	mov    %esi,%eax
    127c:	5b                   	pop    %ebx
    127d:	5e                   	pop    %esi
    127e:	5d                   	pop    %ebp
    127f:	c3                   	ret    

00001280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1280:	b8 01 00 00 00       	mov    $0x1,%eax
    1285:	cd 40                	int    $0x40
    1287:	c3                   	ret    

00001288 <exit>:
SYSCALL(exit)
    1288:	b8 02 00 00 00       	mov    $0x2,%eax
    128d:	cd 40                	int    $0x40
    128f:	c3                   	ret    

00001290 <wait>:
SYSCALL(wait)
    1290:	b8 03 00 00 00       	mov    $0x3,%eax
    1295:	cd 40                	int    $0x40
    1297:	c3                   	ret    

00001298 <pipe>:
SYSCALL(pipe)
    1298:	b8 04 00 00 00       	mov    $0x4,%eax
    129d:	cd 40                	int    $0x40
    129f:	c3                   	ret    

000012a0 <read>:
SYSCALL(read)
    12a0:	b8 05 00 00 00       	mov    $0x5,%eax
    12a5:	cd 40                	int    $0x40
    12a7:	c3                   	ret    

000012a8 <write>:
SYSCALL(write)
    12a8:	b8 10 00 00 00       	mov    $0x10,%eax
    12ad:	cd 40                	int    $0x40
    12af:	c3                   	ret    

000012b0 <close>:
SYSCALL(close)
    12b0:	b8 15 00 00 00       	mov    $0x15,%eax
    12b5:	cd 40                	int    $0x40
    12b7:	c3                   	ret    

000012b8 <kill>:
SYSCALL(kill)
    12b8:	b8 06 00 00 00       	mov    $0x6,%eax
    12bd:	cd 40                	int    $0x40
    12bf:	c3                   	ret    

000012c0 <exec>:
SYSCALL(exec)
    12c0:	b8 07 00 00 00       	mov    $0x7,%eax
    12c5:	cd 40                	int    $0x40
    12c7:	c3                   	ret    

000012c8 <open>:
SYSCALL(open)
    12c8:	b8 0f 00 00 00       	mov    $0xf,%eax
    12cd:	cd 40                	int    $0x40
    12cf:	c3                   	ret    

000012d0 <mknod>:
SYSCALL(mknod)
    12d0:	b8 11 00 00 00       	mov    $0x11,%eax
    12d5:	cd 40                	int    $0x40
    12d7:	c3                   	ret    

000012d8 <unlink>:
SYSCALL(unlink)
    12d8:	b8 12 00 00 00       	mov    $0x12,%eax
    12dd:	cd 40                	int    $0x40
    12df:	c3                   	ret    

000012e0 <fstat>:
SYSCALL(fstat)
    12e0:	b8 08 00 00 00       	mov    $0x8,%eax
    12e5:	cd 40                	int    $0x40
    12e7:	c3                   	ret    

000012e8 <link>:
SYSCALL(link)
    12e8:	b8 13 00 00 00       	mov    $0x13,%eax
    12ed:	cd 40                	int    $0x40
    12ef:	c3                   	ret    

000012f0 <mkdir>:
SYSCALL(mkdir)
    12f0:	b8 14 00 00 00       	mov    $0x14,%eax
    12f5:	cd 40                	int    $0x40
    12f7:	c3                   	ret    

000012f8 <chdir>:
SYSCALL(chdir)
    12f8:	b8 09 00 00 00       	mov    $0x9,%eax
    12fd:	cd 40                	int    $0x40
    12ff:	c3                   	ret    

00001300 <dup>:
SYSCALL(dup)
    1300:	b8 0a 00 00 00       	mov    $0xa,%eax
    1305:	cd 40                	int    $0x40
    1307:	c3                   	ret    

00001308 <getpid>:
SYSCALL(getpid)
    1308:	b8 0b 00 00 00       	mov    $0xb,%eax
    130d:	cd 40                	int    $0x40
    130f:	c3                   	ret    

00001310 <sbrk>:
SYSCALL(sbrk)
    1310:	b8 0c 00 00 00       	mov    $0xc,%eax
    1315:	cd 40                	int    $0x40
    1317:	c3                   	ret    

00001318 <sleep>:
SYSCALL(sleep)
    1318:	b8 0d 00 00 00       	mov    $0xd,%eax
    131d:	cd 40                	int    $0x40
    131f:	c3                   	ret    

00001320 <uptime>:
SYSCALL(uptime)
    1320:	b8 0e 00 00 00       	mov    $0xe,%eax
    1325:	cd 40                	int    $0x40
    1327:	c3                   	ret    

00001328 <settickets>:
SYSCALL(settickets)
    1328:	b8 16 00 00 00       	mov    $0x16,%eax
    132d:	cd 40                	int    $0x40
    132f:	c3                   	ret    

00001330 <getpinfo>:
SYSCALL(getpinfo)
    1330:	b8 17 00 00 00       	mov    $0x17,%eax
    1335:	cd 40                	int    $0x40
    1337:	c3                   	ret    

00001338 <mprotect>:
SYSCALL(mprotect)
    1338:	b8 18 00 00 00       	mov    $0x18,%eax
    133d:	cd 40                	int    $0x40
    133f:	c3                   	ret    

00001340 <munprotect>:
SYSCALL(munprotect)
    1340:	b8 19 00 00 00       	mov    $0x19,%eax
    1345:	cd 40                	int    $0x40
    1347:	c3                   	ret    
